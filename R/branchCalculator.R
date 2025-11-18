
#' Internal Function: Branch Calculator helper function
#'
#' @param data User specified dataframe.
#' @param method Dataframe within the package to retrive beta values from.
#' Options are "LAMBERT_1", "LAMBERT_2", "UNG_1", "UNG_2". 
#' @param output Either "biomass" or "carbon". Biomass gives values in Kg. Carbon gives values in Mg/ha.
#' @param dbh Column within data where Diameter at Breast Height (dbh) is specified.
#' @param height Column within data where Height is specified. 
#' @param species Column within data where species is specified. NFI codes for species.
#' @param crown_cond Column within data where crown condition is specified.
#' @param func Calls function ungEqn1 or ungEqn2.
#' @param appearance Column within data where tree appearance is specified.
#' @param decay Logical with default = TRUE. Should the decay class reduction factor be applied?
#'
#' @returns A vector 
#' @export
#'
#' @examples NA

branchCalculator <- function(data, method, output, dbh, height, species, crown_cond, appearance, func, decay = TRUE) {
  # data = dataframe
  # method = data for model parameters
  # dbh = column from data where DBH is stored
  # height = column from data where HEIGHT is stored
  # species = column from data where SPECIES is stored
  # crown_cond = column from where crown condition is stored
  # appearance = column from where tree appearance is stored
  
  
  branch_biomass <- c() # Empty vector for the For-loop to populate.
  
  for(i in 1:nrow(data)) {
    
    species_spec <- data[[species]][i] # Select a species code to use for beta vals
    
    condition_mod <- ifelse(data[[crown_cond]][i] == 5, 0.5,
                            ifelse(data[[crown_cond]][i] == 4, 0.5,
                                   ifelse(data[[crown_cond]][i] == 3, 0.5,
                                          ifelse(data[[crown_cond]][i] < 3, 1, 0))))
    # if-else to assign a condition modifying coefficient
    
    apperance_mod <- ifelse(data[[appearance]][i] > 5, 0, 1)
    # if-else to assign a condition modifying coefficient
    
    carbon_mod <- ForestBiomass::carbonMod(output)
    # is the output in biomass (Kg) or carbon(Mg/ha)?
    
    decay_mod <- if(decay) {ForestBiomass::DCRF(data, appearance, species = species_spec, i)} else (1)
    # use species specific decay class density modification
    
    beta_list <- ForestBiomass::betaVal(method = method, species = species_spec, component = "BRANCH")
    # beta_list provides a list of 3 beta values that correspond to the specified
    # species and component. Note, WOOD" is hard coded as this is the wood calculation function
    # "method" is provided from the higher level function
    # and species with data frame model parameters should be pulled from
    
    
    branch_val <-  do.call(func, list(data, dbh, height, beta_list, i))
    # Formula 2 from Ung et al., 2008 with the addition of multiplying by
    # modifying coefficients for the condition of the crown and the
    # appearance of the crown. SOURCE???
    
    
    branch_biomass[i] <- (branch_val * condition_mod * apperance_mod * carbon_mod * decay_mod)
    # store the value in the vector created above
    
  }
  
  return(branch_biomass)
  # Function output - a vector
  
}




