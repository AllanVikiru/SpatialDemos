# use of spatial techniques in R
# load data, libraries and shape files

Census.Data <- read.csv("practical_data.csv")
library(sp) 
library(sf)
library(tmap)

Output.Areas<- st_read("./Camden/shapefiles", "Camden_oa11")
OA.Census <- merge(Output.Areas, Census.Data, by.x="OA11CD", by.y="OA")
House.Points <- st_read("./Camden/Camden_house_sales", "Camden_house_sales")

# point in polygon operation: determine if point is within a polygon
pip <- st_intersection(House.Points, OA.Census) #give attributes of polygons of points

# transform to House Points from sf to SpatialPointsDF to allow binding of points to census data
House.Points <-SpatialPointsDataFrame(houses[,3:4], houses, proj4string = CRS("+init=EPSG:27700"))
House.Points@data <- cbind(House.Points@data, pip)

# view  plot and map census data
View(House.Points@data)
plot(log(House.Points@data$Price), House.Points@data$Unemployed)

# measure average house prices per output area
# use reaggregation : aggregate()

# aggregate house prices by OA names, set mean for each oA
OA <- aggregate(House.Points@data$Price, by = list(House.Points@data$OA11CD), mean)
names(OA) <- c("OA11CD", "Price")

#join plot and model aggregated data to OA.Census polygon
OA.Census <- merge(OA.Census, OA, by = "OA11CD", all.x = TRUE)
tm_shape(OA.Census) +tm_borders(alpha=.5)+ tm_fill(col = "Price", style = "quantile", title = "Mean House Price (£)")
prc_model <- lm(OA.Census$Price ~ OA.Census$Unemployed)
summary(prc_model)

#buffering - creating zones that are proximal to identified points on a map
House.Points <-st_as_sf(House.Points)
House.Buffers <- st_buffer(House.Points, 200)
tm_shape(OA.Census) + tm_borders() +
  tm_shape(House.Buffers) + tm_borders(col = "blue") +
  tm_shape(House.Points) + tm_dots(col = "red") 
#union - merging the buffers
union.buffers <- st_union(House.Buffers)
tm_shape(OA.Census) + tm_borders() +
  tm_shape(union.buffers) + tm_fill(col = "blue", alpha = .4) + tm_borders(col = "blue") +
  tm_shape(House.Points) + tm_dots(col = "red") 

# interactive maps in tmap
library(leaflet)

# turns view map on
tmap_mode("view")

#house price data
#dots
tm_shape(House.Points) + 
  tm_dots(title = "House Prices (£)", border.col = "black", border.lwd = 0.1, border.alpha = 0.2, col = "Price", style = "quantile", palette = "Reds") 
#bubbles
tm_shape(House.Points) + 
  tm_bubbles(size = "Price", title.size = "House Prices (£)", border.col = "black", border.lwd = 0.1, border.alpha = 0.4, legend.size.show = TRUE) 
#polygons
tm_shape(OA.Census) + 
  tm_fill("Qualifications", palette = "Reds", style = "quantile", title = "% with a Qualification") + tm_borders(alpha=.4) 
