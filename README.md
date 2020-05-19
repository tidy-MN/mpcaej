
# mpcaej

This package contains two shapefiles provided by the MN Pollution
Control Agency:

  - `ej_shapes` *(blue below)*: Census Tracts polgons and deomgraphic
    data for areas that meet MPCA’s Environmental Justice criteria.

  - `tribe_shapes` *(purple below)*: Areas and names of Tribal Nations
    near Minnesota.

![](ej_map.png)

## Install

To install `mpcaej` from github:

``` r
# First install the 'devtools' package
library(devtools)

# Install the development version from GitHub
remotes::install_github("MPCA-data/mpcaej")
```

-----

## Use

You can load the shapefiles into your workspace by entering their names
in the console after loading the package.

``` r
library(mpcaej)

# Census Tract information
ej <- ej_shapes

# Tribal area polygons
tribes <- tribe_shapes
```

## Leaflet map of shapes

``` r
map_ej()
```

![](ej_map_pop.png)
