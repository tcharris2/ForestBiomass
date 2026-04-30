#' Jenkins Component Ratio Calculation
#'
#' @description Calculates the ratio of each biomass component to total above-ground biomass
#' using Jenkins et al. (2003) equations. Components are foliage, coarse roots, stem bark,
#' and stem wood. Species are classified as softwood or hardwood using \code{SPECIES_CLASS}.
#' Formula: \code{ratio = exp(β₀ + β₁ / DBH)}.
#'
#' @param data User specified dataframe.
#' @param dbh Column within data where Diameter at Breast Height (DBH) is specified (cm).
#' @param species Column within data where species is specified. NFI codes for species.
#'
#' @returns A named list of four numeric vectors: \code{foliage}, \code{coarse_roots},
#' \code{stem_bark}, and \code{stem_wood}.
#' @export
#'
#' @examples jenkinsRatio(data = trees_data, dbh = "DBH", species = "LGTREE_NFI")

jenkinsRatio <- function(data, dbh, species) {

  if (!all(data[[species]] %in% ForestBiomass::SPECIES_CLASS$SPECIES))
    rlang::abort("One or more species not found in SPECIES_CLASS.")

  if (!is.numeric(data[[dbh]]))
    stop("'dbh' must be a numeric vector.", call. = FALSE)

  if (any(is.na(data[[dbh]])))
    message(paste("Warning: NAs detected in", dbh))

  message("Output: component ratios (foliage, coarse_roots, stem_bark, stem_wood)")

  jenkinsRatioCalculator(data, dbh = dbh, species = species)
}
