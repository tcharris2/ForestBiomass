#' Internal Function: Biomass/Carbon output modifier
#'
#' @param output One of "biomass", "biomass Mg/ha", "carbon", or "carbon Mg/ha".
#' @param plot_radius Plot radius in metres. Default 11.28 m.
#'
#' @returns A numeric multiplier applied to raw allometric output (kg) to reach the requested units.
#' @keywords internal
#'
#' @examples carbonMod("biomass")

carbonMod <- function(output, plot_radius = 11.28) {
  ha_mod <- 1 / (pi * plot_radius^2) / 1000
  switch(output,
    "biomass"       = 1,
    "biomass Mg/ha" = ha_mod,
    "carbon"        = 0.5,
    "carbon Mg/ha"  = 0.5 * ha_mod
  )
}
