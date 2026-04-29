#' Root Biomass Calculation
#'
#' @description Calculates below-ground (root) biomass or carbon using species-specific
#' root biomass equations from Li et al. (2003). Requires a pre-computed above-ground
#' biomass column in Mg/ha (e.g. from \code{treeCalc(..., output = "biomass Mg/ha")}).
#' Root decay is not applied and must be handled separately.
#'
#' @param data User specified dataframe.
#' @param biomass Column within data where pre-computed above-ground biomass (Mg/ha) is specified.
#' @param species Column within data where species is specified. NFI codes for species.
#' @param root_type Which root fraction to return. One of "total" (default), "fine", or "coarse".
#' @param output One of "biomass Mg/ha" (default) or "carbon Mg/ha".
#'
#' @returns A numeric vector.
#' @export
#'
#' @examples
#' trees_data$AGB <- treeCalc(trees_data, eval = "ung_2", species = "LGTREE_NFI",
#'   dbh = "DBH", height = "HEIGHT", appearance = "APPEARANCE",
#'   crown_cond = "CROWN_COND", output = "biomass Mg/ha", decay = TRUE)
#' rootCalc(trees_data, biomass = "AGB", species = "LGTREE_NFI")

rootCalc <- function(data, biomass, species,
                     root_type = "total",
                     output = "biomass Mg/ha") {

  if (!all(data[[species]] %in% ForestBiomass::SPECIES_CLASS$SPECIES))
    rlang::abort("One or more species not found in SPECIES_CLASS.")

  if (!is.numeric(data[[biomass]]))
    stop("'biomass' must be a numeric vector.", call. = FALSE)

  if (any(is.na(data[[biomass]])))
    message(paste("Warning: NAs detected in", biomass))

  if (!root_type %in% c("total", "fine", "coarse"))
    rlang::abort("'root_type' must be \"total\", \"fine\", or \"coarse\".")

  if (!output %in% c("biomass Mg/ha", "carbon Mg/ha"))
    rlang::abort("'output' must be \"biomass Mg/ha\" or \"carbon Mg/ha\".")

  message(paste("Output:", output))
  message(paste("Root type:", root_type))

  rootCalculator(data, biomass = biomass, species = species,
                 root_type = root_type, output = output)
}
