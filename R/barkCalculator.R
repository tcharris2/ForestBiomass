#' Internal Function: Bark Calculator helper function
#'
#' @param data User specified dataframe.
#' @param method Dataframe within the package to retrieve beta values from.
#' @param output Either "biomass" or "carbon".
#' @param dbh Column within data where DBH is specified.
#' @param height Column within data where Height is specified.
#' @param species Column within data where species is specified.
#' @param rem_bark Column within data where remaining bark percentage (0-100) is specified.
#' @param func Calls function ungEqn.
#' @param appearance Column within data where tree appearance is specified.
#' @param decay Logical. Should the decay class reduction factor be applied?
#'
#' @returns A vector
#' @export
#'
#' @examples NA

barkCalculator <- function(data, method, output, dbh, height = NULL, species,
                           rem_bark = NULL, func, appearance = NULL, decay = TRUE) {

  carbon_mod <- ForestBiomass::carbonMod(output)
  bark_biomass <- c()

  for (i in seq_len(nrow(data))) {
    species_spec <- data[[species]][i]

    bark_mod <- if (!is.null(rem_bark)) data[[rem_bark]][i] / 100 else 1

    decay_mod <- if (decay) ForestBiomass::DCRF(data, appearance, species = species_spec, i) else 1

    beta_list <- ForestBiomass::betaVal(method = method, species = species_spec, component = "BARK")

    bark_biomass[i] <- func(data, dbh, height, beta_list, i) * bark_mod * carbon_mod * decay_mod
  }

  return(bark_biomass)
}
