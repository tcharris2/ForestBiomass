#' Data: Li et al. (2003) root biomass equation coefficients
#'
#' @format
#' A data frame with 2 rows and 3 columns:
#' \describe{
#'   \item{WOOD_TYPE}{"softwood" or "hardwood"}
#'   \item{BETA_1}{Multiplier coefficient}
#'   \item{BETA_2}{Exponent coefficient}
#' }
#' @details
#' Used in the equation \code{RB = BETA_1 * AB^BETA_2}, where AB is above-ground
#' biomass in Mg/ha and RB is root biomass in Mg/ha.
#' @source Li, Z., Kurz, W.A., Apps, M.J., and Beane, S.J. (2003). Belowground biomass
#' dynamics in the Carbon Budget Model of the Canadian Forest Sector: recent improvements
#' and implications for the estimation of NPP and NEP. Canadian Journal of Forest
#' Research, 33(1): 126-136.
"LI_2003"
