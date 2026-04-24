#' Internal Function: Allometric biomass equation (Ung et al., 2008)
#'
#' @param data User specified dataframe.
#' @param dbh Column within data where DBH is specified.
#' @param height Column within data where Height is specified. NULL for DBH-only equations.
#' @param beta_list Beta values specified from parent function.
#' @param i Row index for iterating.
#'
#' @returns Numeric value.
#' @export
#'
#' @examples NA

ungEqn <- function(data, dbh, height = NULL, beta_list, i) {
  h <- if (!is.null(height)) data[[height]][i]^beta_list[3] else 1
  beta_list[1] * data[[dbh]][i]^beta_list[2] * h
}
