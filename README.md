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

Evalute just one plot

``` r
df<-submission %>% filter(plot_name=="SJER_052")
evaluate_plot(df)
#> [1] "/Library/Frameworks/R.framework/Versions/3.5/Resources/library/NeonTreeEvaluation/extdata/evaluation/RGB//SJER_052.tif"
```

![](README-unnamed-chunk-3-1.png)

    #>   recall precision
    #> 1    0.9         1

A multi-sensor benchmark dataset for detecting individual trees in airborne RGB, Hyperspectral and LIDAR point clouds
=====================================================================================================================

Individual tree detection is a central task in forestry and ecology. Few papers analyze proposed methods across a wide geographic area. This limits the utility of tools and inhibits comparisons across methods. This benchmark dataset is the first dataset to have consistant annotation approach across a variety of ecosystems.

If you would prefer not to clone this repo, a static version of the benchmark is here: \[insert url later\]

Mantainer: Ben Weinstein - University of Florida.

Description: The NeonTreeEvaluation dataset is a set of bounding boxes drawn on RGB imagery from the National Ecological Observation Network (NEON). NEON is a set of 45 sites (e.g. [TEAK](https://www.neonscience.org/field-sites/field-sites-map/TEAK)) that cover the dominant ecosystems in the US.

How were images annotated?
==========================

Each visible tree was annotated to create a bounding box that encompassed all portions of the vertical object. Fallen trees were not annotated. Visible standing stags were annotated. Trees which were judged to have less than 50% of biomass in the image edge were ignored.

<img src="www/rectlabel.png" height="400">

For the point cloud annotations, the two dimensional bounding boxes were [draped](https://github.com/weecology/DeepLidar/blob/b3449f6bd4d0e00c24624ff82da5cfc0a018afc5/DeepForest/postprocessing.py#L13) over the point cloud, and all non-ground points (height &lt; 2m) were excluded. Minor cosmetic cleanup was performed to include missing points. In general, the point cloud annotations should be seen as less thoroughly cleaned, given the tens of thousands of potential points in each image.

Sites ([NEON locations](https://www.neonscience.org/field-sites/field-sites-map/list))
======================================================================================

There are 19 evaluation sites covering a range of terrestrial habitats in the Continent data.

There are currently 4 training data sites: SJER: "Located at The San Joaquin Experimental Range, in the western foothills of the Sierra Nevada, this 18.2 kilometer terrestrial field site is a mix of open woodlands, shrubs and grasslands with low density cattle grazing." \* 2533 training trees, 293 test trees

TEAK: "The site encompasses 5,138 hectares (12,696 acres) of mixed conifer and red fir forest, ranging in elevation from 1,990 to 2,807 m (6,529 – 9,209ft). The varied terrain is typical of the Sierra Nevada, with rugged mountains, meadows and prominent granite outcrops."

-   3405 training tees, 747 test trees.

NIWO: The “alpine” site is Niwot Ridge Mountain Research State, Colorado (40.05425, -105.58237). This high elevation site (3000m) is near treeline with clusters of Subalpine Fir (Abies lasciocarpa) and Englemann Spruce (Picea engelmanii). Trees are very small compared to the others sites.

-   9730 training trees, 1699 test trees.

MLBS: The “Eastern Deciduous” site is the Mountain Lake Biological Station. Here the dense canopy is dominated by Red Maple (Acer rubrum) and White Oak (Quercus alba).

-   1231 training trees, 489 test trees.

For more guidance on data loading, see /utilities.

How can I add to this dataset?
==============================

Anyone is welcome to add to this dataset by cloning this repo and labeling a new site in [rectlabel](https://rectlabel.com/). NEON data is available on the [NEON data server](http://data.neonscience.org/home). We used the NEON 2018 “classified LiDAR point cloud” data 104 product (NEON ID: DP1.30003.001), and the “orthorectified camera mosaic” (NEON ID: 105 DP1.30010.001). Please follow the current folder structure, with .laz and .tif files saved together in a single folder, with a unique name, as well as a single annotations folder for the rect label xml files. See /SJER for an example.

For ease of access, we have added unlabeled training tiles for every evaluation site. Each of these training plots do not overlap with evaluation data.

RGB
===

    library(raster)
    source("functions.R")

    #Read RGB image as projected raster
    rgb<-stack("../SJER/RGB/SJER_021.tif")

    #Path to dataset
    xml<-readTreeXML(path="../annotations/SJER_021.xml")

    #View one plot's annotations as polygons, project into UTM
    #copy project utm zone (epsg), xml has no native projection metadata
    xml_polygons <- xml_to_spatial_polygons(xml,rgb)

    plotRGB(rgb)
    plot(xml_polygons,add=T)

<img src="www/RGB_annotations.png" height="300">

Lidar
=====

To access the draped lidar hand annotations, use the "label" column. Each tree has a unique integer.

    > r<-readLAS("TEAK/training/NEON_D17_TEAK_DP1_315000_4094000_classified_point_cloud_colorized_crop.laz")
    23424 points below 0 found.
    > trees<-lasfilter(r,!label==0)
    > plot(trees,color="label")

<img src="www/lidar_hand_annotations.png" height="300">

We elected to keep all points, regardless of whether they correspond to tree annotation. Non-tree points have value 0. We highly recommend removing these points before predicting the point cloud. Since the annotations were made in the RGB and then draped on to the point cloud, there will naturally be some erroneous points at the borders of trees.

Hyperspectral
=============

``` r
file_path<-system.file("extdata/training", "2018_MLBS_3_541000_4140000_image_crop_false_color.tif",package = "NeonTreeEvaluation")
> r<-stack("file_path")
> r<-r[[c(17,55,113)]]
> nlayers(r)
[1] 3
> plotRGB(r,stretch="lin")
```

<img src="www/Hyperspec_example.png" height="400">

Evaluation plots are named by NEON (e.g. SJER\_059.tif). To find the 1km tile that contains this plot, we have provided an R script to lookup the correct geographic index.

``` r
library(sf)
plot_polygons<-read_sf("/All_NEON_TOS_Plots_V5/All_Neon_TOS_Polygons_V5.shp")

#Look at one site
SJER_plots<-plot_polygons[plot_polygons$siteID=="SJER",]

#View plots
plot(SJER_plots["siteID"],col="black")

#Lookup plotname
plot_record<-as.data.frame(SJER_plots[SJER_plots$plotID=="SJER_059",c("easting","northing")])
geo_index = paste(trunc(plot_record$easting/1000)*1000,trunc(plot_record$northing/1000)*1000,sep="_")
> geo_index
[1] "257000_4109000"
```

Training tiles
==============

The training tiles are large (20GB) and are therefore not included in the R package. They are archived on Zenodo and can downloaded locally using the download\_data() function

Performance
===========

To submit to this benchmark, please see the evaluation vignette. To replicate the benchmark submission from Weinstein et al. 2019 see <https://github.com/weecology/NeonTreeEvaluation>

Cited
-----

<sup>1</sup> Weinstein, Ben G., et al. "Individual tree-crown detection in RGB imagery using semi-supervised deep learning neural networks." Remote Sensing 11.11 (2019): 1309. <https://www.mdpi.com/2072-4292/11/11/1309>

Please submit a pull request, or contact the mantainer if you use these data in analysis and would like the results to be shown here.
