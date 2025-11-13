#' Biomass/Carbon output selection
#'
#' @param output "biomass" or "carbon" 
#'
#' @returns A parameter to modify function output to return either biomass (Kg) or carbon (Mg/ha)
#' @export
#'
#' @examples carbonMod("biomass")



carbonMod <- function(output){
  
  carbon_mod_value <- ForestBiomass::carbon_data[["CARBON_MOD"]][ForestBiomass::carbon_data[["CARBON_METHOD"]] == output]
  
  return(carbon_mod_value)
  
}