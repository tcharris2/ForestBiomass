#' Data: Relative decay reduction factors
#'
#' @format
#' A data frame with 261 rows and 17 columns:
#' \describe{
#'   \item{Genus}{Tree genus name.}
#'   \item{Species}{Tree species name.}
#'   \item{Code}{Original species code from Harmon et al. (2011).}
#'   \item{NFI_CODE}{Adapted species code to match NFI naming.}
#'   \item{...}{Columns DC_1 through DC_5: relative decay reduction factors for each decay class.}
#' }
#' @source Adapted from Harmon et al., 2011 Appendix D. 
#' Added Values:
#' - Populus trichoptera added. Same values as Populus balsamifera
"HARMON_2011"