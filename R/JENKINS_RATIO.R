#' Data: Jenkins et al. (2003) component ratio equation coefficients
#'
#' @format
#' A data frame with 8 rows and 4 columns:
#' \describe{
#'   \item{WOOD_TYPE}{"hardwood" or "softwood"}
#'   \item{COMPONENT}{"foliage", "coarse_roots", "stem_bark", or "stem_wood"}
#'   \item{BETA_0}{Intercept coefficient}
#'   \item{BETA_1}{Slope coefficient}
#' }
#' @details
#' Used in the equation \code{ratio = exp(BETA_0 + BETA_1 / DBH)}, where DBH is
#' in cm and ratio is the proportion of total above-ground biomass allocated to
#' each component.
#' @source Values from Jenkins et al. (2003) National-scale biomass estimators for
#' United States tree species. Forest Science, 49(1): 12-35.
"JENKINS_RATIO"
