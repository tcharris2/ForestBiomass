#' Root Biomass Calculation
#'
#' @description Calculates below-ground (root) biomass or carbon using species-specific
#' root biomass equations from Li et al. (2003). Requires a pre-computed above-ground
#' biomass column. Specify the units of that column via \code{units}; if \code{"kg"},
#' a \code{plot_radius} is required to convert to Mg/ha before applying the equations.
#' Root decay is not applied and must be handled separately.
#'
#' @param data User specified dataframe.
#' @param biomass Column within data where pre-computed above-ground biomass is specified.
#' @param species Column within data where species is specified. NFI codes for species.
#' @param units Units of the biomass column. Must be specified: \code{"Mg/ha"} or \code{"kg"}.
#' @param root_type Which root fraction to return. One of "total" (default), "fine", or "coarse".
#' @param output One of "biomass Mg/ha" (default) or "carbon Mg/ha".
#' @param plot_radius Plot radius in metres. Required when \code{units = "kg"}.
#' Must be one of 3.99, 5.64, 7.98, or 11.28.
#'
#' @returns A numeric vector.
#' @export
#'
#' @examples
#' trees_data$AGB <- treeCalc(trees_data, eval = "ung_2", species = "LGTREE_NFI",
#'   dbh = "DBH", height = "HEIGHT", appearance = "APPEARANCE",
#'   crown_cond = "CROWN_COND", output = "biomass Mg/ha", decay = TRUE)
#' rootCalc(trees_data, biomass = "AGB", species = "LGTREE_NFI", units = "Mg/ha")

rootCalc <- function(data, biomass, species,
                     units,
                     root_type = "total",
                     output = "biomass Mg/ha",
                     plot_radius = NULL) {

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

  if (!units %in% c("Mg/ha", "kg"))
    rlang::abort("'units' must be \"Mg/ha\" or \"kg\".")

  if (units == "kg") {
    if (is.null(plot_radius))
      stop("'plot_radius' is required when units = \"kg\".", call. = FALSE)
    if (!plot_radius %in% c(3.99, 5.64, 7.98, 11.28))
      stop("'plot_radius' must be one of 3.99, 5.64, 7.98, or 11.28.", call. = FALSE)
    con_fact <- c("3.99" = 200, "5.64" = 100, "7.98" = 50, "11.28" = 25)
    ha_mod <- unname(con_fact[as.character(plot_radius)]) / 1000
    data[[biomass]] <- data[[biomass]] * ha_mod
  }

  message(paste("Input units:", units))
  message(paste("Output:", output))
  message(paste("Root type:", root_type))

  rootCalculator(data, biomass = biomass, species = species,
                 root_type = root_type, output = output)
}
