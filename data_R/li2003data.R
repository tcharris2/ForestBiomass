# Root biomass equation coefficients from Li et al. (2003).
# Equation form: RB = BETA_1 * AB^BETA_2
# where AB is above-ground biomass (Mg/ha) and RB is root biomass (Mg/ha).

LI_2003 <- data.frame(
  WOOD_TYPE = c("softwood", "hardwood"),
  BETA_1    = c(0.222, 1.576),
  BETA_2    = c(1.000, 0.615),
  stringsAsFactors = FALSE
)

usethis::use_data(LI_2003, overwrite = TRUE)
