#' Internal Function: ungEqn2
#'
#' @param data User specified dataframe.
#' @param dbh Column within data where Diameter at Breast Height (dbh) is specified.
#' @param height Column within data where Height is specified. 
#' @param beta_list specified from parent function
#' @param i for iterating
#'
#' @returns value (numeric)
#' @export
#'
#' @examples NA

ungEqn2 <- function(data, dbh, height, beta_list, i){
  
  beta_list[1] * (data[[dbh]][i]^beta_list[2]) * (data[[height]][i]^beta_list[3])
  
}
