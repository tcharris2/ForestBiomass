#' Internal Function: Biomass/Carbon output modifier
#'
#' @param output One of "biomass", "biomass Mg/ha", "carbon", or "carbon Mg/ha".
#' @param plot_radius Plot radius in metres. One of 3.99, 5.64, 7.98, or 11.28. Default 11.28 m.
#'
#' @returns A numeric multiplier applied to raw allometric output (kg) to reach the requested units.
#' @keywords internal
#'
#' @examples carbonMod("biomass")

carbonMod <- function(output, plot_radius = 11.28) {
  con_fact <- c("3.99" = 200, "5.64" = 100, "7.98" = 50, "11.28" = 25)
  ha_mod <- con_fact[as.character(plot_radius)] / 1000
  switch(output,
    "biomass"       = 1,
    "biomass Mg/ha" = ha_mod,
    "carbon"        = 0.5,
    "carbon Mg/ha"  = 0.5 * ha_mod
  )
}
