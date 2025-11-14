
#' Internal Function: Wood Calculator helper function
#'
#' @param data User specified dataframe.
#' @param method Dataframe within the package to retrive beta values from.
#' Options are "LAMBERT_1", "LAMBERT_2", "UNG_1", "UNG_2". 
#' @param output Either "biomass" or "carbon". Biomass gives values in Kg. Carbon gives values in Mg/ha.
#' @param dbh Column within data where Diameter at Breast Height (dbh) is specified.
#' @param height Column within data where Height is specified. 
#' @param species Column within data where species is specified. NFI codes for species.
#' @param func Calls function ungEqn1 or ungEqn2.
#' @param appearance Column within data where tree appearance is specified.
#' @param decay Logical with default = TRUE. Should the decay class reduction factor be applied?
#'
#' @returns A vector 
#' @export
#'
#' @examples NA



woodCalculator <- function(data, method, output, dbh, height, species, func, appearance, decay = TRUE) {
  # data = dataframe
  # method = data for model parameters
  # dbh = column from data where DBH is stored
  # height = column from data where HEIGHT is stored
  # species = column from data where SPECIES is stored
  
  wood_biomass <- c() # Empty vector for the For-loop to populate.
  
  for(i in 1:nrow(data)) {
    
    species_spec <- data[[species]][i]
    # Select a species code to use for beta vals
    
    carbon_mod <- carbonMod(output)
    # is the output in biomass (Kg) or carbon(Mg/ha)?
    
    decay_mod <- if(decay) {DCRF(data, appearance, species = species_spec, i) } else (1)
    # use species specific decay class density modification
    
    beta_list <- betaVals(method = method, species = species_spec, component = "WOOD")
    # beta_list provides a list of 3 beta values that correspond to the specified
    # species and component. Note, WOOD" is hard coded as this is the wood calculation function
    # "method" is provided from the higher level function
    # and species with data frame model parameters should be pulled from
    
    wood_val <- do.call(func, list(data, dbh, height, beta_list, i))
    # "func" allows for a call between Eqn 1 or 2 from Ung et al., 2008
    
    wood_biomass[i] <- (wood_val * carbon_mod * decay_mod)
    # store the value in the vector created above
    
  }
  
  return(wood_biomass)
  # Function output - a vector
  
}




