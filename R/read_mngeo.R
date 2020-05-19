#' Get Shapefiles from the MN Geocommons
#'
#' Downloads the shapefile from a MN Geocommons webpage at https://gisdata.mn.gov/.
#'
#' Example data source
#' MPCA EJ areas: https://gisdata.mn.gov/dataset/env-ej-mpca-census
#'
#' @param path Directory to save the ZIP file to, if necessary.
#'
#' @param folder_name Name of folder to save downloaded ZIP file to, if necessary.
#'
#' @param add_date If TRUE, add today's date to the folder name. Helps to prevent overwriting existing folders.
#'
#' @examples
#' library(mpcaej)
#'
#' \dontrun{
#' ej <- read_mngeo(url = "https://gisdata.mn.gov/dataset/env-ej-mpca-census", layer = "ej_mpca_census.shp")
#'
#' ej[1, ]
#'
#' plot(ej[ , 1])
#' }
#'
#' @export

read_mngeo <- function(url = "https://resources.gisdata.mn.gov/pub/gdrs/data/pub/us_mn_state_pca/env_ej_mpca_census/shp_env_ej_mpca_census.zip",
                       layer        = "ej_mpca_census.shp",
                       path         = getwd(),
                       folder_name  = "mngeo_shapes",
                       add_date     = TRUE) {

  # Begin download
  print("Downloading shapefile...")

  # Create new folder, if it doesn't exist
  folder_path <- paste0(path, "/", folder_name, "_", Sys.Date())

  if(!dir.exists(folder_path)) dir.create(folder_path)

  # Get ZIP file name
  zip_file <- strsplit(url, "/")[[1]]

  zip_file <- zip_file[length(zip_file)]

  zip_file <- paste0(folder_path, "/", zip_file)

  ## Get Shapefile
  download.file(url, zip_file)

  unzip(zip_file, exdir = folder_path)

  shapes <- sf::st_read(paste0(folder_path, "/", layer))

  # Clean house
  names(shapes) <- tolower(names(shapes))

  shapes <- dplyr::mutate_if(shapes, is.factor, as.character())

  print("Success!")

  return(shapes)

}

