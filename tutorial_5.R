#load shape file: geographic info

library(sf, terra, stars) #recommended packages after retirement of rgdal and rgeos

#load output area(OA)
Output.Areas<- st_read("./Camden/shapefiles", "Camden_oa11")
plot(Output.Areas)

#merge census attributes to OA
OA.Census <- merge(Output.Areas, Census.Data, by.x="OA11CD", by.y="OA")

#set coordinate system to British National Grid
oa_coord <- st_crs(OA.Census) %>% st_crs("+init=EPSG:27700")

#mapping data
library(tmap, leaflet)

#qualifications map
qtm(OA.Census, fill = "Qualifications")

#enhance map graphics: borders, polygons, symbology, layout
tm_shape(OA.Census) + tm_fill("Qualifications") # simple choropleth

library(RColorBrewer) # colour palettes
display.brewer.all()

tm_shape(OA.Census) + tm_fill("Qualifications", palette = "-Blues") # - sign inverts degree of colouration (deep shades to represent low values)

# data intervals style parameter
# equal - divides the range of the variable into n parts.
# pretty - chooses a number of breaks to fit a sequence of equally spaced ‘round’ values. So they keys for these intervals are always tidy and memorable.
# quantile - equal number of cases in each group
# jenks - looks for natural breaks in the data
# Cat - if the variable is categorical (i.e. not continuous data

tm_shape(OA.Census) + tm_fill("Qualifications",  style = "quantile", palette = "Reds")

# add number of levels to quantile
tm_shape(OA.Census) + tm_fill("Qualifications",  style = "quantile", n=7, palette = "YlOrRd")

# includes a histogram in the legend
tm_shape(OA.Census) + tm_fill("Qualifications", style = "jenks", palette = "Oranges", legend.hist = TRUE) 

# add borders and compass
tm_shape(OA.Census) + tm_fill("Qualifications", palette = "Accent") + 
  tm_borders(alpha=.7) + tm_compass()

#edit map layout
# adds in layout, gets rid of frame
tm_shape(OA.Census) + tm_fill("Qualifications", palette = "Spectral", style = "quantile", title = "% with a Qualification") + 
  tm_borders(alpha=.4) + 
  tm_compass() + 
  tm_layout(title = "Camden, London", legend.text.size = 1.1, legend.title.size = 1.4, legend.position = c("right", "top"), frame = FALSE)
