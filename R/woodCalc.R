#' Wood Calculation
#'
#' @description Calculates wood biomass or carbon per tree given either DBH or DBH and Height.
#' Calculations are done base on the allometric equations provided in Ung et al., 2008 or Lambert et al., 2005.
#' A species specific decay class reduction factor can be applied (Harmon et al., 2011) if desired.
#'
#' @param data User specified dataframe.
#' @param eval Which allomentic equation should be used? Default is set to Ung Equation 2 where biomass is calculated
#' with both DBH and Height. Options are: "ung_1" for DBH based calculations, "ung_2" for DBH and Height based calculations,
#' "lambert_1" for DBH based calculations, and "lambert_2" for DBH and Height based calculations. Use Ung equations for
#' within British Columbia and use Lambert equations for species found in Eastern Canada.
#' @param dbh Column within data where Diameter at Breast Height (dbh) is specified.
#' @param height Optional. Required if using lambert_2 or ung_2. Column within data where Height is specified.
#' @param species Column within data where species is specified. NFI codes for species.
#' @param appearance Optional. Required when decay = TRUE. Column within data where tree appearance is specified.
#' @param output Either "biomass" (default) or "carbon". Biomass gives values in Kg. Carbon gives values in Mg/ha.
#' @param decay Logical with default = TRUE. Should the decay class reduction factor be applied?
#'
#' @returns A vector.
#' @export
#'
#' @examples woodCalc(data = trees_data,
#' eval = "ung_2",
#' species = "LGTREE_NFI",
#' dbh = "DBH",
#' height = "HEIGHT",
#' appearance = "APPEARANCE",
#' output = "biomass",
#' decay = TRUE)

woodCalc <- function(data, eval = "ung_2",
                     dbh, height = NULL, species, appearance = NULL,
                     output = "biomass", decay = TRUE) {

  if (!eval %in% c("ung_1", "ung_2", "lambert_1", "lambert_2"))
    rlang::abort("Specified Method Not Available")

  validateSpecies(data[[species]], eval)

  if (!is.numeric(data[[dbh]]))
    stop("'dbh' must be a numeric vector.", call. = FALSE)

  if (any(is.na(data[[dbh]])))
    message(paste("Warning: NAs detected in", dbh))

  if (eval %in% c("lambert_2", "ung_2")) {
    if (is.null(height))
      stop(paste0("'height' is required for ", eval, "."), call. = FALSE)
    if (any(is.na(data[[height]])))
      message(paste("Warning: NAs detected in", height))
  }

  if (!output %in% c("biomass", "carbon"))
    rlang::abort("'output' must be \"biomass\" or \"carbon\".")

  if (decay && is.null(appearance))
    stop("'appearance' is required when decay = TRUE.", call. = FALSE)

  message(paste("Output:", output, if (output == "biomass") "(kg)" else "(Mg/ha)"))
  if (decay) message("Species specified decay reduction factor applied (Harmon et al., 2011)")

  sel <- resolveMethod(eval, height)
  woodCalculator(data, func = sel$func, method = sel$method, output = output,
                 dbh = dbh, height = sel$height, species = species,
                 appearance = appearance, decay = decay)

}
