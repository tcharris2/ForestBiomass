#' Internal Function: Jenkins Calculator
#'
#' @param data User specified dataframe.
#' @param dbh Column within data where DBH is specified.
#' @param species Column within data where species is specified. NFI codes.
#' @param appearance Column within data where tree appearance is specified.
#' @param output Either "biomass" or "carbon".
#' @param decay Logical. Should the decay class reduction factor be applied?
#'
#' @returns A vector
#' @keywords internal
#' @examples NA

jenkinsCalculator <- function(data, dbh, species, appearance = NULL, output, decay) {

  carbon_mod <- carbonMod(output)
  result <- numeric(nrow(data))

  for (i in seq_len(nrow(data))) {
    species_spec <- data[[species]][i]

    group  <- ForestBiomass::JENKINS_GROUPS$SPECIES_GROUP[
                ForestBiomass::JENKINS_GROUPS$SPECIES == species_spec]
    beta_0 <- ForestBiomass::JENKINS$BETA_0[ForestBiomass::JENKINS$SPECIES_GROUP == group]
    beta_1 <- ForestBiomass::JENKINS$BETA_1[ForestBiomass::JENKINS$SPECIES_GROUP == group]

    bm <- exp(beta_0 + beta_1 * log(data[[dbh]][i]))

    decay_mod <- if (decay) DCRF(data, appearance, species = species_spec, i) else 1

    result[i] <- bm * decay_mod * carbon_mod
  }

  return(result)
}
