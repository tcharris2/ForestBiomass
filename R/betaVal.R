#' Internal function: Beta Values
#'
#' @param method Dataframe within the package to retrive beta values from.
#' Options are "LAMBERT_1", "LAMBERT_2", "UNG_1", "UNG_2". 
#' @param species gets specifed from parent function. Will be an NFI code
#' @param component one of "WOOD", "BARK", "BRANCHES" or "FOLIAGE".
#'
#' @returns A list of 2 or 3 beta values
#' @export
#'
#' @examples NA

betaVal <- function(method, species = species_spec, component = component_spec) {
  # UNG_df to be stored in the package
  # species and component to be specified by the function above this one
  
  # Select correct beta values
  beta1 <- with(method, VALUE[SPECIES == species & COMPONENT == component & BETA_NUM == 1])
  
  beta2 <- with(method, VALUE[SPECIES == species & COMPONENT == component & BETA_NUM == 2])
  
  beta3 <- with(method, VALUE[SPECIES == species & COMPONENT == component & BETA_NUM == 3])
  
  # function output
  return(c(beta1, beta2, beta3))
  
}


