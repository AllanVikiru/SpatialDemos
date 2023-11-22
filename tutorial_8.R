# representing densities
# load data, libraries and shape files
Census.Data <- read.csv("practical_data.csv")
library(sp) 
library(sf)
library(tmap)
library(raster)
library(adehabitatHR)

Output.Areas<- st_read("./Camden/shapefiles", "Camden_oa11")
OA.Census <- merge(Output.Areas, Census.Data, by.x="OA11CD", by.y="OA")
House.Points <- st_read("./Camden/Camden_house_sales", "Camden_house_sales") # price house data shapefile
houses <- read.csv("./Camden/camdenhousesales15.csv")
houses <- houses[, c(1,2,8,9)] # price house raw data

### Point Densities: run the kernel density estimation
hse_coords <- SpatialPointsDataFrame(coordinates(cbind(House.Points$oseast1m, House.Points$osnrth1m)),data = houses, proj4string = CRS("+init=EPSG:27700"))
kde.output <- kernelUD(hse_coords, h="href", grid = 1000)

plot(kde.output)

### set as contour map : requires raster format
kde <- raster(kde.output) # converts to raster
projection(kde) <- CRS("+init=EPSG:27700") # set projection to British National Grid
library(tmap)
tm_shape(kde) + tm_raster("ud") # maps the raster in tmap, "ud" is the density variable

### set contour map to Camden area
library(tmaptools) # set of tools for processing spatial data

# creates a bounding box based on the extents of the Output.Areas polygon
bounding_box <- bb(Output.Areas)

# maps the raster within the bounding box
tm_shape(kde, bbox = bounding_box) + tm_raster("ud")

# clip the raster by the output area polygon : reserves areas only covered within output area
masked_kde <- mask(kde, Output.Areas)

# maps the masked raster, also maps white output area boundaries
tm_shape(masked_kde, bbox = bounding_box) +
  tm_raster("ud", style = "quantile", n = 100, legend.show = FALSE, palette = "YlGnBu") +
  tm_shape(Output.Areas) + tm_borders(alpha=.3, col = "white") +
  tm_layout(frame = FALSE)


### create and plot catchment boundaries
# compute homeranges for 75%, 50%, 25% of points, objects are returned as spatial polygon data frames
range75 <- getverticeshr(kde.output, percent = 75)
range50 <- getverticeshr(kde.output, percent = 50)
range25 <- getverticeshr(kde.output, percent = 25)
range10 <- getverticeshr(kde.output, percent = 10)

tm_shape(Output.Areas) + tm_fill(col = "#f0f0f0") + tm_borders(alpha=.8, col = "white") + # create layer of output areas
  tm_shape(House.Points) + tm_dots(col = "blue") + # create layer of house point prices
  tm_shape(range75) + tm_borders(alpha=.7, col = "#fb6a4a", lwd = 2) + tm_fill(alpha=.1, col = "#fb6a4a") +
  tm_shape(range50) + tm_borders(alpha=.7, col = "#de2d26", lwd = 2) + tm_fill(alpha=.1, col = "#de2d26") +
  tm_shape(range25) + tm_borders(alpha=.7, col = "#a50f15", lwd = 2) + tm_fill(alpha=.1, col = "#a50f15") + 
  tm_shape(range10) + tm_borders(alpha=.7, col = "#AA4A44", lwd = 2) + tm_fill(alpha=.1, col = "#AA4A44") +
  # catchment areas layers
  tm_layout(frame = FALSE) # remove frame

# export raster
writeRaster(masked_kde, filename = "kernel_density.grd")