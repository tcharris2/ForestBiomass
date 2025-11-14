#' Decay Class Reduction Factor (DCRF)
#'
#' @param data User dataframe.
#' @param appearance Column from user dataframe where tree appearance is specified. 
#' Appearance codes correspond to Field Manual for Describing Terrestrial Ecosystems 2nd edition.
#' @param species Column from user dataframe with species code. Species code must be in NFI format.
#' @param i Used for iterating.
#'
#' @returns A decay modifer (numeric) corresponding to species and decay class
#' @export
#'
#' @examples NA
DCRF <- function(data, appearance, species, i){
  
  dec_reduc <- if(data[[appearance]][i] < 3)
  { 1 } else
    
    if(data[[appearance]][i] == 3)
    { HARMON_2011$rel1[HARMON_2011$NFI_CODE == species] } else
      
      if(data[[appearance]][i] == 4)
      { HARMON_2011$rel2[HARMON_2011$NFI_CODE == species] } else
        
        if(data[[appearance]][i] == 5)
        { HARMON_2011$rel3[HARMON_2011$NFI_CODE == species] } else
          
          if(data[[appearance]][i] >= 6)
          { HARMON_2011$rel4[HARMON_2011$NFI_CODE == species] }
  
  return(dec_reduc)
  
}


# Here i use appearance as an approximation for decay class.
# Appearance code 3-7 from field_manual_describing_terrestrial_ecosystems_2nd BC Ministry of forests
# Are an approximation for decay classes 1-5 Harmon et al., 2011.
