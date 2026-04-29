#' Tree Biomass Calculation
#'
#' @description Calculates total above-ground tree biomass or carbon. Two methodologies
#' are available: (1) summing wood, branch, foliage, and bark components using allometric
#' equations from Ung et al., 2008 or Lambert et al., 2005; or (2) direct total
#' above-ground biomass via Jenkins et al., 2003 national-scale equations.
#' A species-specific decay class reduction factor (Harmon et al., 2011) can be applied.
#'
#' @param data User specified dataframe.
#' @param eval Which equation set to use. Default is "ung_2". Options are:
#' "ung_1", "ung_2", "lambert_1", "lambert_2" (component-sum pathway), or
#' "jenkins" (Jenkins et al., 2003 direct total biomass).
#' @param dbh Column within data where Diameter at Breast Height (dbh) is specified.
#' @param height Optional. Required for "lambert_2" or "ung_2".
#' @param species Column within data where species is specified. NFI codes for species.
#' @param appearance Optional. Required when decay = TRUE.
#' @param crown_cond Column within data where crown condition is specified. Required
#' for "ung_1", "ung_2", "lambert_1", "lambert_2". Not used with "jenkins".
#' @param rem_bark Optional. Column within data where remaining bark percentage (0-100)
#' is specified. Not used with "jenkins".
#' @param output Either "biomass" (default, kg) or "carbon" (Mg/ha).
#' @param decay Logical with default = TRUE. Should the decay class reduction factor be applied?
#'
#' @returns A vector.
#' @export
#'
#' @examples treeCalc(data = trees_data, eval = "ung_2", species = "LGTREE_NFI",
#' dbh = "DBH", height = "HEIGHT", appearance = "APPEARANCE",
#' crown_cond = "CROWN_COND", output = "biomass", decay = TRUE)
#'
#' treeCalc(data = trees_data, eval = "jenkins", species = "LGTREE_NFI",
#' dbh = "DBH", appearance = "APPEARANCE", output = "biomass", decay = TRUE)

treeCalc <- function(data, eval = "ung_2",
                     dbh, height = NULL, species, appearance = NULL,
                     crown_cond = NULL, rem_bark = NULL,
                     output = "biomass", decay = TRUE) {

  if (!eval %in% c("ung_1", "ung_2", "lambert_1", "lambert_2", "jenkins"))
    rlang::abort("Specified Method Not Available")

  if (eval == "jenkins") {
    if (!is.null(crown_cond))
      message("'crown_cond' is not used with eval = 'jenkins' and will be ignored.")
    if (!is.null(rem_bark))
      message("'rem_bark' is not used with eval = 'jenkins' and will be ignored.")

    if (!all(data[[species]] %in% ForestBiomass::JENKINS_GROUPS$SPECIES))
      rlang::abort("One or more species not found in JENKINS_GROUPS.")

    if (!is.numeric(data[[dbh]]))
      stop("'dbh' must be a numeric vector.", call. = FALSE)

    if (any(is.na(data[[dbh]])))
      message(paste("Warning: NAs detected in", dbh))

    if (!output %in% c("biomass", "carbon"))
      rlang::abort("'output' must be \"biomass\" or \"carbon\".")

    if (decay && is.null(appearance))
      stop("'appearance' is required when decay = TRUE.", call. = FALSE)

    message(paste("Output:", output, if (output == "biomass") "(kg)" else "(Mg/ha)"))
    if (decay) message("Species specified decay reduction factor applied (Harmon et al., 2011)")

    return(jenkinsCalculator(data, dbh = dbh, species = species,
                              appearance = appearance, output = output, decay = decay))
  }

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

  if (is.null(crown_cond))
    stop("'crown_cond' is required when eval is not 'jenkins'.", call. = FALSE)

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
