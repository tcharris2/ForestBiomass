# Component ratio equation coefficients from Jenkins et al. (2003).
# Equation form: ratio = exp(BETA_0 + BETA_1 / DBH)
# where DBH is in cm and ratio is the proportion of total above-ground biomass.
# Components: foliage, coarse_roots, stem_bark, stem_wood.

JENKINS_RATIO <- data.frame(
  WOOD_TYPE = rep(c("hardwood", "softwood"), each = 4),
  COMPONENT = rep(c("foliage", "coarse_roots", "stem_bark", "stem_wood"), 2),
  BETA_0    = c(-4.0813, -1.6911, -2.01129, -0.3065,
               -2.9584, -1.5619, -2.0980,  -0.3737),
  BETA_1    = c( 5.8816,  0.8160, -1.6805,  -5.4240,
                4.4766,  0.6614, -1.1432,  -1.8055),
  stringsAsFactors = FALSE
)

usethis::use_data(JENKINS_RATIO, overwrite = TRUE)
