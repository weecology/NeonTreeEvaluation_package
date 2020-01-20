#' Retrieve benchmark data
#' \code{get_data} is a set of utility functions for finding the path of benchmark data on disk
#' @param plot_name A plot name
#' @param sensor Which plot object should be returned: "rgb","lidar","hyperspectral","annotations"
#' @return path to object on disk
#' @export

get_data<-function(plot_name, sensor){
  if(sensor=="rgb"){
    path<-get_rgb(plot_name)
  }
  if(sensor=="lidar"){
    path<-get_lidar(plot_name)
  }
  if(sensor=="hyperspectral"){
    path<-get_hyperspectral(plot_name)
  }
  if(sensor=="annotations"){
    path<-get_annotations(plot_name)
  }
  return(path)
}

get_rgb<-function(plot_name){
  path<-paste(system.file("extdata","evaluation/RGB/",package="NeonTreeEvaluation"),"/",plot_name,".tif",sep="")
  return(path)
}

get_lidar<-function(plot_name){
  path<-paste(system.file("extdata","evaluation/LiDAR/",package="NeonTreeEvaluation"),"/",plot_name,".laz",sep="")
  return(path)
}

get_hyperspectral<-function(plot_name){
  path<-paste(system.file("extdata","evaluation/Hyperspectral/",package="NeonTreeEvaluation"),"/",plot_name,"_hyperspectral.tif",sep="")
  return(path)
}

get_annotations<-function(plot_name){
  path<-paste(system.file("extdata","annotations/",package="NeonTreeEvaluation"),"/",plot_name,".xml",sep="")
  return(path)
}
