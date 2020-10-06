context("Check IoU")
library(dplyr)

test_that("IoU computes correct value", {
  #Two nested boxes, one of area 4 one of area 1
  x<-st_sf(geometry=st_sfc(st_polygon(list(matrix(c(0,0,2,2,0,0,2,2,0,0),ncol=2)))))
  y<-st_sf(geometry=st_sfc(st_polygon(list(matrix(c(1,1,2,2,1,1,2,2,1,1),ncol=2)))))

  #intersection = 1, union = 4, IoU is herefore 0.25
  expect_equal(IoU(x,y),0.25)
})

test_that("IoU computes correct value if partial overlap", {
  #Two nested boxes, one of area 9 one of area 9, overlap of area 4.
  x<-st_sf(geometry=st_sfc(st_polygon(list(matrix(c(0,0,3,3,0,0,3,3,0,0),ncol=2)))))
  y<-st_sf(geometry=st_sfc(st_polygon(list(matrix(c(1,1,4,4,1,1,4,4,1,1),ncol=2)))))

  #intersection = 4, union = 14, IoU is herefore  4/14 = 0.286
  expect_equal(IoU(x,y),4/14)
})

test_that("IoU returns 0 on no overlap ", {
  #Two nested boxes, one of area 4 one of area 2
  x<-st_sf(geometry=st_sfc(st_polygon(list(matrix(c(0,0,2,2,0,0,2,2,0,0),ncol=2)))))
  y<-st_sf(geometry=st_sfc(st_polygon(list(matrix(c(10,10,20,20,10,10,20,20,10,10),ncol=2)))))

  #intersection = 0
  expect_equal(IoU(x,y),0)
})


