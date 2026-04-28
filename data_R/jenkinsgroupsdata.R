# Maps NFI species codes to Jenkins et al. (2003) species groups.
# Coverage: union of Ung and Lambert dataset species, excluding ambiguous catch-alls.

JENKINS_GROUPS <- data.frame(
  SPECIES = c("PICE_MAR", "PSEU_MEN", "PICE_ENG", "PINU_CON", "ABIE_AMA", "ALNU_RUB",
              "POPU_TRI", "PICE_SIT", "ABIE_LAS", "POPU_TRE", "TSUG_HET", "THUJ_PLI",
              "BETU_PAP", "PICE_GLA", "ABIE_BAL", "POPU_BAL", "TILI_AME", "FAGU_GRA",
              "FRAX_NIG", "PRUN_SER", "TSUG_CAN", "JUNI_VIR", "THUJ_OCC", "PINU_STR",
              "BETU_POP", "CARY_SPP", "OSTR_VIR", "PINU_BAN", "POPU_GRA", "FRAX_PEN",
              "ACER_RUB", "QUER_RUB", "PINU_RES", "PICE_RUB", "ACER_SAC", "ACER_SAH",
              "LARI_LAR", "FRAX_AME", "ULMU_AME", "QUER_ALB", "BETU_ALL",
              "GENH_SPP", "GENC_SPP"),
  SPECIES_GROUP = c("Spruce", "Douglas-fir", "Spruce", "Pine", "True fir/hemlock",
                    "Aspen/alder/cottonwood/willow", "Aspen/alder/cottonwood/willow",
                    "Spruce", "True fir/hemlock", "Aspen/alder/cottonwood/willow",
                    "True fir/hemlock", "Cedar/larch", "Soft maple/birch", "Spruce",
                    "True fir/hemlock", "Aspen/alder/cottonwood/willow", "Mixed hardwood",
                    "Hard maple/oak/hickory/beech", "Mixed hardwood", "Mixed hardwood",
                    "True fir/hemlock", "Cedar/larch", "Cedar/larch", "Pine",
                    "Soft maple/birch", "Hard maple/oak/hickory/beech", "Mixed hardwood",
                    "Pine", "Aspen/alder/cottonwood/willow", "Mixed hardwood",
                    "Soft maple/birch", "Hard maple/oak/hickory/beech", "Pine",
                    "Spruce", "Soft maple/birch", "Hard maple/oak/hickory/beech",
                    "Cedar/larch", "Mixed hardwood", "Mixed hardwood",
                    "Hard maple/oak/hickory/beech", "Soft maple/birch",
                    "Mixed hardwood", "Mixed softwood")
)
