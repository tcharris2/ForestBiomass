# Simulated BC tree measurements used as a shared fixture in package vignettes.
sample_trees <- data.frame(
  SPECIES    = c("PSEU_MEN", "PINU_CON", "TSUG_HET", "POPU_TRE", "PICE_MAR", "PICE_GLA"),
  DBH        = c(32.4, 18.7, 14.2, 27.6,  9.8, 41.3),
  HEIGHT     = c(22.1, 14.5, 11.8, 20.3,  8.4, 28.7),
  APPEARANCE = c(   1,    1,    3,    2,    5,    1),
  CROWN_COND = c(   1,    2,    3,    1,    4,    1),
  stringsAsFactors = FALSE
)

usethis::use_data(sample_trees, overwrite = TRUE)
