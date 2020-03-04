<!-- README.md is generated from README.Rmd. Please edit that file -->
NeonTreeEvaluation
==================

[![Travis-CI Build Status](https://travis-ci.org/Weecology/NeonTreeEvaluation_package.svg?branch=master)](https://travis-ci.org/Weecology/NeonTreeEvaluation_package)

The goal of NeonTreeEvaluation is to automate testing against the NEON Tree Detection Benchmark

# Installation

```
library(devtools)
install_github("https://github.com/weecology/NeonTreeEvaluation_package.git")
```

Submission Format
=================

The format of the submission is as follows

-   A csv file
-   5 columns: Plot Name, xmin, ymin, xmax, ymax

Each row contains information for one predicted bounding box.

The plot column should be named the same as the files in the dataset (e.g. SJER\_021)

``` r
library(NeonTreeEvaluation)
library(dplyr)
submission<-read.csv(system.file("extdata", "Weinstein2019.csv",package = "NeonTreeEvaluation"))
head(submission)
#>   plot_name       xmin       ymin     xmax      ymax
#> 1  BLAN_005 299.532560  13.216835 396.9573 123.17089
#> 2  BLAN_005   6.189451 217.012850 113.7897 325.25092
#> 3  BLAN_005 255.822100 181.132950 309.3961 245.84946
#> 4  BLAN_005 256.380600 283.993260 334.1573 376.96796
#> 5  BLAN_005 107.644630   5.248255 177.9518  85.23382
#> 6  BLAN_005 173.360230 341.138150 255.3800 400.00000
```

### Evaluate Benchmark
```
result<-evaluate_benchmark(submission, project_boxes=TRUE,show=F)
#Summary recall and precision
summary_statistics(result)
#By geographic site
summary_statistics(result,method="site")
```


``` r
df<-submission %>% filter(plot_name=="SJER_052")
evaluate_plot(df)
#> [1] "/Library/Frameworks/R.framework/Versions/3.5/Resources/library/NeonTreeEvaluation/extdata/evaluation/RGB//SJER_052.tif"
```

![](README-unnamed-chunk-3-1.png)

    #>   recall precision
    #> 1    0.9         1

To submit to this benchmark, please see the evaluation vignette. To replicate the benchmark submission from Weinstein et al. 2019 see <https://github.com/weecology/NeonTreeEvaluation>

## Visualizing Data

# RGB

```R
library(raster)
library(NeonTreeEvaluation)

#Read RGB image as projected raster
rgb_path<-get_data(plot_name = "SJER_021",sensor="rgb")
rgb<-stack(rgb_path)

#Path to dataset
xmls<-readTreeXML(siteID="SJER")

#View one plot's annotations as polygons, project into UTM
#copy project utm zone (epsg), xml has no native projection metadata
xml_polygons <- boxes_to_spatial_polygons(xmls[xmls$filename %in% "SJER_021.tif",],rgb)

plotRGB(rgb)
plot(xml_polygons,add=T)
```

# Lidar

To access the draped lidar hand annotations, use the "label" column. Each tree has a unique integer.

```R
library(lidR)
path<-get_data("TEAK_052",sensor="lidar")
r<-readLAS(path)
trees<-lasfilter(r,!label==0)
plot(trees,color="label")
```

We elected to keep all points, regardless of whether they correspond to tree annotation. Non-tree points have value 0. We  recommend removing these points before evaluating the point cloud. Since the annotations were made in the RGB and then draped on to the point cloud, there will be some erroneous points at the borders of trees.

# Hyperspectral 

Hyperspectral surface reflectance (NEON ID: DP1.30006.001) is a 426 band raster covering visible and near infared spectrum.

```R
path<-get_data("MLBS_071",sensor="hyperspectral")
g<-stack(path)
nlayers(g)
[1] 426
#Grab a three band combination to view as false color
g<-g[[c(17,55,113)]]
nlayers(g)
[1] 3
plotRGB(g,stretch="lin")
```

Cited
-----

<sup>1</sup> Weinstein, Ben G., et al. "Individual tree-crown detection in RGB imagery using semi-supervised deep learning neural networks." Remote Sensing 11.11 (2019): 1309. <https://www.mdpi.com/2072-4292/11/11/1309>

Please submit a pull request, or contact the mantainer if you use these data in analysis and would like the results to be shown here.
