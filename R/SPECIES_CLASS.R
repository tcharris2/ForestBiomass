#' Data: NFI species softwood/hardwood classification
#'
#' @format
#' A data frame with 43 rows and 2 columns:
#' \describe{
#'   \item{SPECIES}{NFI species code}
#'   \item{WOOD_TYPE}{"softwood" or "hardwood"}
#' }
#' @details
#' Maps NFI species codes to a softwood/hardwood classification for use with
#' root biomass equations. Coverage is the union of species present in the
#' Ung et al. (2008) and Lambert et al. (2005) datasets, excluding ambiguous
#' catch-all codes (GENA_SPP, ALL_SPP, HARD_SPP, SOFT_SPP).
#' @source Species classification based on standard forestry taxonomy.
"SPECIES_CLASS"
