#' Tree Biomass Calculation
#'
#' @description Calculates total above-ground tree biomass or carbon by summing
#' wood, branch, foliage, and bark components. Calculations are based on the
#' allometric equations provided in Ung et al., 2008 or Lambert et al., 2005.
#' A species-specific decay class reduction factor (Harmon et al., 2011) can be applied.
#'
#' @param data User specified dataframe.
#' @param eval Which allometric equation should be used? Default is "ung_eqn_2". Options are:
#' "ung_eqn_1", "ung_eqn_2", "lambert_eqn_1", "lambert_eqn_2".
#' @param dbh Column within data where Diameter at Breast Height (dbh) is specified.
#' @param height Optional. Required for lambert_eqn_2 or ung_eqn_2.
#' @param species Column within data where species is specified. NFI codes for species.
#' @param appearance Optional. Required when decay = TRUE.
#' @param crown_cond Column within data where crown condition is specified.
#' @param rem_bark Optional. Column within data where remaining bark percentage (0-100) is specified.
#' @param output Either "biomass" (default, kg) or "carbon" (Mg/ha).
#' @param decay Logical with default = TRUE. Should the decay class reduction factor be applied?
#' @param include_root Logical with default = FALSE. Should root biomass be included?
#' rootCalc() is not yet implemented; setting this to TRUE will raise an error.
#'
#' @returns A vector.
#' @export
#'
#' @examples treeCalc(data = trees_data, eval = "ung_eqn_2", species = "LGTREE_NFI",
#' dbh = "DBH", height = "HEIGHT", appearance = "APPEARANCE",
#' crown_cond = "CROWN_COND", output = "biomass", decay = TRUE)

treeCalc <- function(data, eval = "ung_eqn_2",
                     dbh, height = NULL, species, appearance = NULL,
                     crown_cond, rem_bark = NULL,
                     output = "biomass", decay = TRUE, include_root = FALSE) {

  if (!eval %in% c("ung_eqn_1", "ung_eqn_2", "lambert_eqn_1", "lambert_eqn_2"))
    rlang::abort("Specified Method Not Available")

  if (include_root)
    rlang::abort("rootCalc() is not yet implemented. Set include_root = FALSE.")

  validateSpecies(data[[species]], eval)

  if (!is.numeric(data[[dbh]]))
    stop("'dbh' must be a numeric vector.", call. = FALSE)

  if (any(is.na(data[[dbh]])))
    message(paste("Warning: NAs detected in", dbh))

  if (eval %in% c("lambert_eqn_2", "ung_eqn_2")) {
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

  wood    <- suppressMessages(woodCalc(data, eval = eval, dbh = dbh, height = height,
                                       species = species, appearance = appearance,
                                       output = output, decay = decay))
  bark    <- suppressMessages(barkCalc(data, eval = eval, dbh = dbh, height = height,
                                       species = species, appearance = appearance,
                                       rem_bark = rem_bark, output = output, decay = decay))
  branch  <- suppressMessages(branchCalc(data, eval = eval, dbh = dbh, height = height,
                                         species = species, appearance = appearance,
                                         crown_cond = crown_cond, output = output, decay = decay))
  foliage <- suppressMessages(foliageCalc(data, eval = eval, dbh = dbh, height = height,
                                          species = species, appearance = appearance,
                                          crown_cond = crown_cond, output = output, decay = decay))

  wood + bark + branch + foliage
}
