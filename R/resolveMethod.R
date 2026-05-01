#' Internal: Resolve allometric method, equation function, and height for dispatch
#'
#' @param eval The allometric equation method string.
#' @param height Column name for height, or NULL.
#'
#' @returns A list with func, method, and resolved height (NULL for DBH-only equations).
#' @keywords internal

resolveMethod <- function(eval, height) {
  methods <- list(
    lambert_1 = list(func = ungEqn, method = ForestBiomass::LAMBERT_1),
    lambert_2 = list(func = ungEqn, method = ForestBiomass::LAMBERT_2),
    ung_1    = list(func = ungEqn, method = ForestBiomass::UNG_1),
    ung_2    = list(func = ungEqn, method = ForestBiomass::UNG_2)
  )
  sel <- methods[[eval]]
  sel$height <- if (eval %in% c("ung_1", "lambert_1")) NULL else height
  sel
}
