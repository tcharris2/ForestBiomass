# Coefficients for Jenkins et al. (2003) total above-ground biomass equation:
# bm = exp(BETA_0 + BETA_1 * ln(DBH)), where bm is in kg and DBH is in cm.
# "Mixed softwood" is an in-house addition: arithmetic mean of beta coefficients
# across Cedar/larch, Douglas-fir, True fir/hemlock, Pine, and Spruce.

JENKINS <- data.frame(
  SPECIES_GROUP = c("Cedar/larch", "Douglas-fir", "True fir/hemlock", "Pine", "Spruce",
                    "Aspen/alder/cottonwood/willow", "Soft maple/birch", "Mixed hardwood",
                    "Hard maple/oak/hickory/beech", "Juniper/oak/mesquite", "Mixed softwood"),
  BETA_0 = c(-2.0336, -2.2304, -2.5384, -2.5356, -2.0773,
              -2.2094, -1.9123, -2.4800, -2.0127, -0.7152, -2.2831),
  BETA_1 = c(2.2592, 2.4435, 2.4814, 2.4249, 2.3323,
              2.3867, 2.3651, 2.4835, 2.4342, 1.7029, 2.3883)
)
