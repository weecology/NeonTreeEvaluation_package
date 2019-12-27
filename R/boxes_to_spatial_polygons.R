#' Convert xml annotations into projected bounding boxes.
#' In order to plot the annotations, they need to be projected and overlayed on RGB boxes
#'
#' @param boxes a boxesframe with xmin, xmax, ymin, ymax columns. Each row is a tree bounding box
#' @param raster_object a rgb raster::stack to overlay annotations
#' @param project_boxes inherited from \code{\link{evaluate_plot}}, whether boxes need to be projected to utm from image coordinates (origin 0,0 top left)
#' @return SpatialPolygons object of annotations
#' @export
#'
#'
#boxes is a xml object returned by the parser above, raster_object is the projected RGB image
boxes_to_spatial_polygons<-function(boxes,raster_object,project_boxes=TRUE){

  if(project_boxes){
    boxes<-project(boxes,raster_object)
  }

  projected_polygons<-list()
  for(x in 1:nrow(boxes)){
    e<-raster::extent(c(boxes$xmin[x],
                       boxes$xmax[x],
                       boxes$ymin[x],
                       boxes$ymax[x]))
    projected_polygons[[x]]<-as(e, 'SpatialPolygons')
    projected_polygons[[x]]@polygons[[1]]@ID<-as.character(x)
  }

  projected_polygons <- as(sp::SpatialPolygons(lapply(projected_polygons,
                                                  function(x) slot(x, "polygons")[[1]])),"SpatialPolygonsDataFrame")

  projected_polygons@data$crown_id=1:nrow(projected_polygons)
  sp::proj4string(projected_polygons)<-raster::projection(raster_object)
  return(projected_polygons)
}
