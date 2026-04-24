#' Internal Function: Validate Species Input
#'
#' @param species_input Vector of species codes from user data.
#' @param eval The allometric equation method string.
#'
#' @returns NULL invisibly; aborts if species are invalid.

validateSpecies <- function(species_input, eval) {
  species_all <- if (startsWith(eval, "lambert")) unique(ForestBiomass::LAMBERT_1[["SPECIES"]])
                 else unique(ForestBiomass::UNG_1[["SPECIES"]])
  if (!all(species_input %in% species_all))
    rlang::abort("Species input does not match specified method. See documentation for valid species.")
}
