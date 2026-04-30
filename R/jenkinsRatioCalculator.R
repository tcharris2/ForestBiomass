#' Internal Function: Jenkins Ratio Calculator
#'
#' @param data User specified dataframe.
#' @param dbh Column within data where DBH is specified (cm).
#' @param species Column within data where species is specified. NFI codes.
#'
#' @returns A named list of four numeric vectors: foliage, coarse_roots, stem_bark, stem_wood.
#' @keywords internal
#' @examples NA

jenkinsRatioCalculator <- function(data, dbh, species) {

  components <- c("foliage", "coarse_roots", "stem_bark", "stem_wood")
  n      <- nrow(data)
  result <- setNames(lapply(components, function(x) numeric(n)), components)

  for (i in seq_len(n)) {
    wood_type <- ForestBiomass::SPECIES_CLASS$WOOD_TYPE[
      ForestBiomass::SPECIES_CLASS$SPECIES == data[[species]][i]]

    sub <- ForestBiomass::JENKINS_RATIO[ForestBiomass::JENKINS_RATIO$WOOD_TYPE == wood_type, ]

    for (comp in components) {
      row <- sub[sub$COMPONENT == comp, ]
      result[[comp]][i] <- exp(row$BETA_0 + row$BETA_1 / data[[dbh]][i])
    }
  }

  result
}
