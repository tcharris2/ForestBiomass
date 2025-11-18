#' Branch Calculation
#'
#' @description Calculates branch biomass or carbon per tree given either DBH or DBH and Height.
#' Calculations are done base on the allometric equations provided in Ung et al., 2008 or Lambert et al., 2005.
#' A species specific decay class reduction factor can be applied (Harmon et al., 2011) if desired. 
#' 
#' @param data User specified dataframe.
#' @param eval Which allomentic equation should be used? Default is set to Ung Equation 2 where biomass is calculated 
#' with both DBH and Height. Options are: "ung_eqn_1" for DBH based calculations, "ung_eqn_2" for DBH and Height based calculations,
#' "lambert_eqn_1" for DBH based calculations, and "lambert_eqn_2" for DBH and Height based calculations. Use Ung equations for
#' within British Columbia and use Lambert equations for species found in Eastern Canada.
#' @param dbh Column within data where Diameter at Breast Height (dbh) is specified.
#' @param height Column within data where Height is specified. 
#' @param species Column within data where species is specified. NFI codes for species.
#' @param crown_cond Column within data where crown condition is specified.
#' @param appearance Column within data where tree appearance is specified.
#' @param output Either "biomass" (default) or "carbon". Biomass gives values in Kg. Carbon gives values in Mg/ha.
#' @param decay Logical with default = TRUE. Should the decay class reduction factor be applied?
#'
#' @returns A vector.
#' @export 
#'
#' @examples branchCalc(data = trees_data,
#' eval = "ung_eqn_2",
#' species = "LGTREE_NFI",
#' dbh = "DBH",
#' height = "HEIGHT",
#' appearance = "APPEARANCE",
#' crown_cond = "CROWN_COND",
#' output = "biomass",
#' decay = TRUE)
#' 
#'

branchCalc <- function(data, eval = "ung_eqn_2",
                       dbh, height, appearance, species, crown_cond,
                       output = "biomass", decay = TRUE){
  
  # Function checks ------------------------------------------------------------
  
  # Check to make sure correct method is specified.
  if(!eval %in% c("ung_eqn_1", "ung_eqn_2", "lambert_eqn_1", "lambert_eqn_2")) {
    rlang::abort("Specified Method Not Avaliable")
  }
  
  # Check to make sure species are correctly specified.
  species_input <- data[[species]]
  species_all <- if(startsWith(eval, "lambert")) {unique(ForestBiomass::LAMBERT_1[["SPECIES"]])
  } else
    if(startsWith(eval, "ung")){unique(ForestBiomass::UNG_1[["SPECIES"]])
    }
  
  if(!all(species_input %in% species_all)) {
    rlang::abort("Species input does not match specifed method.
  Please see documentation for a complete list of species.")
  }
  
  # NA checks
  
  # DBH is always specified
  if(any(is.na(data[[dbh]]))) {
    message(paste("Warning: NAs detected in", dbh))
  }
  
  # Height is only specified in certain equations
  if(eval %in% c("lambert_eqn_2", "ung_eqn_2")) {
    if(any(is.na(data[[height]]))) {
      message(paste("Warning: NAs detected in", height))
    }
  }
  
  # Helper message -------------------------------------------------------------
  
  # Tell the user what the output is in units of
  
  message(paste("Output:", output,
                if (output == "biomass") {"(kg)"} else
                  if(output == "carbon"){"(Mg/ha)"}))
  if(decay) {message("Species specified decay reduction factor applied (Harmon et al., 2011)")}
  
  # Function output ------------------------------------------------------------
  
  # Lambert equation 1
  if(eval == "lambert_eqn_1") {
    
    do.call(ForestBiomass::branchCalculator, list(data, func = ungEqn1, method = LAMBERT_1,
                                                  output, dbh, height = NULL, species, crown_cond,
                                                  appearance = appearance, decay))
  } else
    
    # Lambert equation 2
    if(eval == "lambert_eqn_2") {
      
      do.call(ForestBiomass::branchCalculator, list(data, func = ungEqn2, method = LAMBERT_2,
                                                    output, dbh, height, species, crown_cond,
                                                    appearance = appearance, decay))
    } else
      
      # Ung equation 1
      if(eval == "ung_eqn_1") {
        
        do.call(ForestBiomass::branchCalculator, list(data, func = ungEqn1, method = UNG_1,
                                                      output, dbh, height = NULL, species, crown_cond,
                                                      appearance = appearance, decay))
      } else
        # Ung equation 2
        if(eval == "ung_eqn_2") {
          
          do.call(ForestBiomass::branchCalculator, list(data, func = ungEqn2, method = UNG_2,
                                                        output, dbh, height, species, crown_cond,
                                                        appearance = appearance, decay))
          
        }
  
  
}
