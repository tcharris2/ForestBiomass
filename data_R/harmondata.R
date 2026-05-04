# Relative decay reduction factors from Harmon et al. (2011) Appendix D.
# Columns: Genus, Species, Code, NFI_CODE, den0, rel1-rel4, unc1-unc4, cod1-cod4
# den0 = density at decay class 0; rel1-4 = relative reduction factors for decay classes 1-4

HARMON_2011 <- read.csv("data_R/Harmon_2011_appendixD.csv", stringsAsFactors = FALSE)

usethis::use_data(HARMON_2011, overwrite = TRUE)
