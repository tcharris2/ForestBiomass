#' Internal Function: Branch Calculator helper function
#'
#' @param data User specified dataframe.
#' @param method Dataframe within the package to retrieve beta values from.
#' @param output Either "biomass" or "carbon".
#' @param dbh Column within data where DBH is specified.
#' @param height Column within data where Height is specified.
#' @param species Column within data where species is specified.
#' @param crown_cond Column within data where crown condition is specified.
#' @param func Calls function ungEqn.
#' @param appearance Column within data where tree appearance is specified.
#' @param decay Logical. Should the decay class reduction factor be applied?
#'
#' @returns A vector
#' @export
#'
#' @examples NA

branchCalculator <- function(data, method, output, dbh, height = NULL, species,
                             crown_cond, func, appearance = NULL, decay = TRUE) {

  carbon_mod <- ForestBiomass::carbonMod(output)
  branch_biomass <- c()

  for (i in seq_len(nrow(data))) {
    species_spec <- data[[species]][i]

    condition_mod <- ifelse(data[[crown_cond]][i] == 5, 0.5,
                            ifelse(data[[crown_cond]][i] == 4, 0.5,
                                   ifelse(data[[crown_cond]][i] == 3, 0.5,
                                          ifelse(data[[crown_cond]][i] < 3, 1, 0))))

    appearance_mod <- ifelse(data[[appearance]][i] > 5, 0, 1)

    decay_mod <- if (decay) ForestBiomass::DCRF(data, appearance, species = species_spec, i) else 1

    beta_list <- ForestBiomass::betaVal(method = method, species = species_spec, component = "BRANCH")

    branch_biomass[i] <- func(data, dbh, height, beta_list, i) * condition_mod * appearance_mod * carbon_mod * decay_mod
  }

  return(branch_biomass)
}
