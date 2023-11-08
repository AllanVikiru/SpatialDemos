#load point data to shapefile
library(sf)

# data of house sales with lat and long attributes for postcodes
houses <- read.csv("./Camden/camdenhousesales15.csv")
houses <- houses[, c(1,2,8,9)]
plot(houses$osnrth1m, houses$oseast1m)

# convert house data to spatial format
library(sp)
House.Points <-SpatialPointsDataFrame(houses[,3:4], houses, proj4string = CRS("+init=EPSG:27700"))

#create blank map as layer
library(tmap)
tm_shape(OA.Census) +tm_borders(alpha=.5)

# add points
tm_shape(OA.Census) + tm_borders(alpha=.5) +
  tm_shape(House.Points) + 
  tm_dots(col="Price", palette="Reds", scale = 1.5, style="quantile", title = "Price Paid (£)") + 
  tm_compass() + tm_layout(legend.text.size = 0.9, legend.title.size = 1.3, frame = FALSE)

# proportional points
tm_shape(OA.Census) + tm_borders(alpha=.5) +
  tm_shape(House.Points) + 
  tm_bubbles(size="Price",col="Price", palette="Blues", style="quantile", legend.size.show= FALSE, title.col = "Price Paid (£)") + 
  tm_compass() + tm_layout(legend.text.size = 0.9, legend.title.size = 1.3, frame = FALSE)

#include independent variable as choropleth map
tm_shape(OA.Census) + 
  tm_fill("Qualifications", palette="Reds", style="quantile", title="% Qualifications") + 
  tm_borders(alpha=.4) + 
  tm_shape(House.Points) + 
  tm_bubbles(size="Price",col="Price", palette="Blues", style="quantile", legend.size.show= FALSE, title.col = "Price Paid (£)", border.col="black", border.lwd=0.1, border.alpha=0.1) + 
  tm_layout(legend.text.size = 0.6, legend.title.size = 0.7, frame = FALSE)

# export generated shapefile
Hse_Sf <- st_as_sf(House.Points) # convert from SP dataframe to sf object
st_write(Hse_Sf, "./Camden/Camden_house_sales", driver = "ESRI Shapefile") #export files to Camden_house_sales folder 