#' Get MPCA's Environmental Justice Shapefiles from the MN Geocommons
#'
#' Download the polygon shapefile of Tribal Areas used by MPCA in their Environmental Justice Framework

#'
#' Data sources
#' MN GEOCOMMONS: https://gisdata.mn.gov/
#' EJ areas: https://gisdata.mn.gov/dataset/env-ej-mpca-census
#'
#' @param path Directory to save the ZIP file to, if necessary.
#'
#' @param folder_name Name of folder to save downloaded ZIP file to, if necessary.
#'
#' @param add_date If TRUE, add today's date to the folder name. Helps to prevent overwriting existing folders.
#'
#' @param use_latlong Return shapefile with lat/long coordinates (WGS 84). Default is X/Y coordinates in UTM 15N.
#'
#' @param data_only Drop the spatial geometry and return a data frame of only the demographic information.
#'
#' @examples
#' library(mpcaej)
#'
#' \dontrun{
#' tribes <- get_tribes()
#'
#' tribes[1, ]
#'
#' plot(tribes[ , 1])
#' }
#'
#' @export

get_tribal_areas <- function(
                       path         = getwd(),
                       folder_name  = "mpca_tribal_areas",
                       add_date     = TRUE,
                       use_latlong  = TRUE,
                       data_only    = FALSE) {

  # Data sources
  ## MN GEOCOMMONS: https://gisdata.mn.gov/
  ## EJ areas: https://gisdata.mn.gov/dataset/env-ej-mpca-census

  web_text <- readr::read_lines("https://gisdata.mn.gov/dataset/env-ej-mpca-census")

  # Check for updates
  updated <- function() {

     date_text <- web_text[grepl("dataset-details", web_text)]

     sum(grepl("2023-07-25", date_text)) < 1

  }

  updated <- tryCatch(updated(), error = function(e) NA)

  #e <- new.env()

  # If check fails, use saved version
  if (is.na(updated)) {

      message("Update check failed. Returning the archived file from July, 2023.")

      #(tribe_shapes, envir = e)

      shapes <- tribe_shapes

      # Transform to lat/long if needed
      if (use_latlong) shapes <- sf::st_transform(shapes, 4326)

      # Drop geometry if requested
      if (data_only) shapes <- sf::st_set_geometry(shapes, NULL)


  } else if (!updated) { # If no updates, use saved version

      message("No updates found for tribal areas. Returning the archived file from July, 2023")

      #data(ej_shapes, envir = e) #envir = globalenv())

      shapes <- tribe_shapes

      # Transform to lat/long if needed
      if (use_latlong) shapes <- sf::st_transform(shapes, 4326)

      # Drop geometry if requested
      if (data_only) shapes <- sf::st_set_geometry(shapes, NULL)


  } else {

     # Otherwise begin download
     message("New version available.")

     ## Get Shapefile
     shp_url <- "https://resources.gisdata.mn.gov/pub/gdrs/data/pub/us_mn_state_pca/env_ej_mpca_census/shp_env_ej_mpca_census.zip"

     tribe_layer <- "census_tribal_areas.shp"

     shapes <- read_mngeo(url          = shp_url,
                          layer        = tribe_layer,
                          path         = path,
                          folder_name  = folder_name,
                          add_date     = add_date)

     # Transform to lat/long if needed
     if(use_latlong) shapes <- sf::st_transform(shapes, 4326)

     # Drop geometry if requested
     if(data_only) shapes <- sf::st_set_geometry(shapes, NULL)
  }

    return(shapes)
}

