#' Bark Calculation
#'
#' @description Calculates bark biomass or carbon per tree given either DBH or DBH and Height.
#' Calculations are done base on the allometric equations provided in Ung et al., 2008 or Lambert et al., 2005.
#' A species specific decay class reduction factor can be applied (Harmon et al., 2011) if desired.
#'
#' @param data User specified dataframe.
#' @param eval Which allomentic equation should be used? Default is "ung_2". Options are:
#' "ung_1", "ung_2", "lambert_1", "lambert_2".
#' @param dbh Column within data where Diameter at Breast Height (dbh) is specified.
#' @param height Optional. Required for lambert_2 or ung_2.
#' @param species Column within data where species is specified. NFI codes for species.
#' @param appearance Optional. Required when decay = TRUE.
#' @param rem_bark Optional. Column within data where remaining bark percentage (0-100) is specified.
#' @param output One of "biomass" (kg, default), "biomass Mg/ha", "carbon" (kg), or "carbon Mg/ha".
#' @param decay Logical with default = TRUE. Should the decay class reduction factor be applied?
#' @param plot_radius Plot radius in metres used to compute the per-hectare expansion factor. Default 11.28 m.
#'
#' @returns A vector.
#' @export
#'
#' @examples barkCalc(data = trees_data, eval = "ung_2", species = "LGTREE_NFI",
#' dbh = "DBH", height = "HEIGHT", appearance = "APPEARANCE",
#' rem_bark = "REM_BARK", output = "biomass", decay = TRUE)

barkCalc <- function(data, eval = "ung_2",
                     dbh, height = NULL, species, appearance = NULL, rem_bark = NULL,
                     output = "biomass", decay = TRUE, plot_radius = 11.28) {

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

  if (!output %in% c("biomass", "biomass Mg/ha", "carbon", "carbon Mg/ha"))
    rlang::abort("'output' must be \"biomass\", \"biomass Mg/ha\", \"carbon\", or \"carbon Mg/ha\".")

  if (decay && is.null(appearance))
    stop("'appearance' is required when decay = TRUE.", call. = FALSE)

  units <- if (grepl("Mg/ha", output)) "(Mg/ha)" else "(kg)"
  message(paste("Output:", output, units))
  if (decay) message("Species specified decay reduction factor applied (Harmon et al., 2011)")

  sel <- resolveMethod(eval, height)
  barkCalculator(data, func = sel$func, method = sel$method, output = output,
                 dbh = dbh, height = sel$height, species = species,
                 rem_bark = rem_bark, appearance = appearance, decay = decay,
                 plot_radius = plot_radius)
}
