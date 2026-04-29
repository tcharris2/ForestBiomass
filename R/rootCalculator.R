#' Internal Function: Root Biomass Calculator
#'
#' @param data User specified dataframe.
#' @param biomass Column within data where pre-computed above-ground biomass (Mg/ha) is specified.
#' @param species Column within data where species is specified. NFI codes for species.
#' @param root_type One of "total", "fine", or "coarse".
#' @param output One of "biomass Mg/ha" or "carbon Mg/ha".
#'
#' @returns A numeric vector.
#' @keywords internal
#'
#' @examples NA

rootCalculator <- function(data, biomass, species, root_type, output) {

  carbon_mod <- if (output == "carbon Mg/ha") 0.5 else 1
  result <- numeric(nrow(data))

  for (i in seq_len(nrow(data))) {
    species_i <- data[[species]][i]
    ab        <- data[[biomass]][i]

    wood_type <- ForestBiomass::SPECIES_CLASS$WOOD_TYPE[ForestBiomass::SPECIES_CLASS$SPECIES == species_i]
    beta_row  <- ForestBiomass::LI_2003[ForestBiomass::LI_2003$WOOD_TYPE == wood_type, ]

    rb <- beta_row$BETA_1 * ab ^ beta_row$BETA_2

    if (root_type != "total") {
      pf <- 0.072 + 0.354 * exp(-0.060 * rb)
      rb <- if (root_type == "fine") pf * rb else (1 - pf) * rb
    }

    result[i] <- rb * carbon_mod
  }

  result
}
