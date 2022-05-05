library(leaflet)
m = leaflet()
m = addTiles(m) # Add default OpenStreetMap map tiles
m = addMarkers(m, lng=121.51, lat=25.05, popup="Taipei Station")
m#新增座標點