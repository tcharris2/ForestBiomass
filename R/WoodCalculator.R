
#' Internal Function: Wood Calculator helper function
#'
#' @param data User specified dataframe.
#' @param method Dataframe within the package to retrive beta values from.
#' Options are "LAMBERT_1", "LAMBERT_2", "UNG_1", "UNG_2".
#' @param output One of "biomass", "biomass Mg/ha", "carbon", or "carbon Mg/ha".
#' @param plot_radius Plot radius in metres for per-hectare expansion. Default 11.28 m.
#' @param dbh Column within data where Diameter at Breast Height (dbh) is specified.
#' @param height Column within data where Height is specified.
#' @param species Column within data where species is specified. NFI codes for species.
#' @param func Calls function ungEqn.
#' @param appearance Column within data where tree appearance is specified.
#' @param decay Logical with default = TRUE. Should the decay class reduction factor be applied?
#'
#' @returns A vector
#' @keywords internal
#'
#' @examples NA

woodCalculator <- function(data, method, output, dbh, height = NULL, species, func, appearance = NULL, decay = TRUE, plot_radius = 11.28) {

  carbon_mod <- carbonMod(output, plot_radius)
  wood_biomass <- c()

  for (i in seq_len(nrow(data))) {
    species_spec <- data[[species]][i]
    decay_mod <- if (decay) DCRF(data, appearance, species = species_spec, i) else 1
    beta_list <- betaVal(method = method, species = species_spec, component = "WOOD")
    wood_biomass[i] <- func(data, dbh, height, beta_list, i) * carbon_mod * decay_mod
  }

  return(wood_biomass)

}
