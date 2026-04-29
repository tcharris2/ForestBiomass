# Maps NFI species codes to softwood/hardwood classification for Li et al. (2003)
# root biomass equations. Coverage: union of Ung and Lambert dataset species,
# excluding ambiguous catch-all codes (GENA_SPP, ALL_SPP, HARD_SPP, SOFT_SPP).

SPECIES_CLASS <- data.frame(
  SPECIES = c(
    # Softwoods (20)
    "PICE_MAR", "PSEU_MEN", "PICE_ENG", "PINU_CON", "ABIE_AMA", "PICE_SIT",
    "ABIE_LAS", "TSUG_HET", "THUJ_PLI", "PICE_GLA", "ABIE_BAL", "TSUG_CAN",
    "THUJ_OCC", "PINU_STR", "PINU_BAN", "PINU_RES", "PICE_RUB", "JUNI_VIR",
    "GENC_SPP", "LARI_LAR",
    # Hardwoods (23)
    "ALNU_RUB", "POPU_TRI", "POPU_TRE", "BETU_PAP", "POPU_BAL", "TILI_AME",
    "FAGU_GRA", "FRAX_NIG", "PRUN_SER", "BETU_POP", "CARY_SPP", "OSTR_VIR",
    "POPU_GRA", "FRAX_PEN", "ACER_RUB", "QUER_RUB", "ACER_SAC", "ACER_SAH",
    "FRAX_AME", "ULMU_AME", "QUER_ALB", "BETU_ALL", "GENH_SPP"
  ),
  WOOD_TYPE = c(
    rep("softwood", 20),
    rep("hardwood", 23)
  ),
  stringsAsFactors = FALSE
)

usethis::use_data(SPECIES_CLASS, overwrite = TRUE)
