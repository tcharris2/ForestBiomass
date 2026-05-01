# Maps NFI species codes to Jenkins et al. (2003) species groups.
# Coverage: union of Ung and Lambert dataset species.
# GENA_SPP excluded: too broad to assign to any single Jenkins group (combines hardwoods and softwoods).
# GENH_SPP and GENC_SPP are retained because they map cleanly to hardwood/softwood groups.

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
                    "True fir/hemlock", "Juniper/oak/mesquite", "Cedar/larch", "Pine",
                    "Soft maple/birch", "Hard maple/oak/hickory/beech", "Mixed hardwood",
                    "Pine", "Aspen/alder/cottonwood/willow", "Mixed hardwood",
                    "Soft maple/birch", "Hard maple/oak/hickory/beech", "Pine",
                    "Spruce", "Soft maple/birch", "Hard maple/oak/hickory/beech",
                    "Cedar/larch", "Mixed hardwood", "Mixed hardwood",
                    "Hard maple/oak/hickory/beech", "Soft maple/birch",
                    "Mixed hardwood", "Mixed softwood")
)

# PICE_MAR = Black spruce
# PSEU_MEN = Douglas-fir
# PICE_ENG = Engelmann spruce
# PINU_CON = Lodgepole pine
# ABIE_AMA = Amabilis fir
# ALNU_RUB = Red alder
# POPU_TRI = Black cottonwood
# PICE_SIT = Sitka spruce
# ABIE_LAS = Subalpine fir
# POPU_TRE = Trembling aspen
# TSUG_HET = Western hemlock
# THUJ_PLI = Western red cedar
# BETU_PAP = White/paper birch
# PICE_GLA = White spruce
# ABIE_BAL = Balsam fir
# POPU_BAL = Balsam poplar
# TILI_AME = Basswood
# FAGU_GRA = Beech
# FRAX_NIG = Black ash
# PRUN_SER = Black cherry
# TSUG_CAN = Eastern hemlock
# JUNI_VIR = Eastern redcedar
# THUJ_OCC = Eastern white-cedar
# PINU_STR = Eastern white pine
# BETU_POP = Grey birch
# CARY_SPP = Hickory
# OSTR_VIR = Hop-hornbeam
# PINU_BAN = Jack pine
# POPU_GRA = Largetooth aspen
# FRAX_PEN = Red ash
# ACER_RUB = Red maple
# QUER_RUB = Red oak
# PINU_RES = Red pine
# PICE_RUB = Red spruce
# ACER_SAC = Silver maple
# ACER_SAH = Sugar maple
# LARI_LAR = Tamarack larch
# FRAX_AME = White ash
# ULMU_AME = White elm
# QUER_ALB = White oak
# BETU_ALL = Yellow birch
# GENH_SPP = All hardwoods (Ung)
# GENC_SPP = All softwoods (Ung)
