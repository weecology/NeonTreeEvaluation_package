
sf_to_spatial_polygons <- function(predictions, rgb){
  #pixels to meters
  scaled_submission<-sf::st_geometry(predictions) * raster::res(rgb)[1]

  # Project, do ymax before ymin to avoid overwriting, numpy origin is topleft
  coords<-data.frame(st_coordinates(scaled_submission))

  projection_extent <- raster::extent(rgb)
  coords$X <- projection_extent@xmin + coords$X
  coords$Y <- projection_extent@ymax - coords$Y

  polygons <- coords %>% group_by(L2) %>%
    st_as_sf(coords = c("X", "Y"), crs = raster::crs(rgb)) %>%
    summarise(geometry = st_combine(geometry)) %>%
    st_cast("POLYGON") %>% as.data.frame()

  #drop current geom
  st_geometry(predictions)<-NULL

  projected_polygons<-st_sf(data.frame(predictions,polygons))
  projected_polygons$crown_id <- 1:nrow(projected_polygons)

  return(projected_polygons)
  }
