# Model parameter estimates for the DBH-HEIGHT-based set of equations for each species,
# for all hardwoods, for all softwoods, and for all species combined


UNG_2 <- data.frame(SPECIES = rep(c("PICE_MAR", "PSEU_MEN", "PICE_ENG", "PINU_CON", "ABIE_AMA", "ALNU_RUB",
                                    "POPU_TRI", "PICE_SIT", "ABIE_LAS", "POPU_TRE", "TSUG_HET", "THUJ_PLI",
                                    "BETU_PAP", "PICE_GLA", "GENH_SPP", "GENC_SPP", "GENA_SPP"), each = 12),
                    #beta = beta,
                    COMPONENT = c("WOOD", "WOOD", "WOOD", "BARK", "BARK", "BARK",
                                  "BRANCH", "BRANCH", "BRANCH", "FOLIAGE", "FOLIAGE", "FOLIAGE"),
                    BETA_NUM = c(1, 2, 3),
                    VALUE =  c(0.0335, 1.7389, 0.9835, 0.0132, 1.7657, 0.5775, 0.0405, 3.1917, -1.3674, 0.2078, 2.5517, -1.3453, # PICE_MAR
                               0.0191, 1.5365, 1.3634, 0.0083, 2.4811, 0.0000, 0.0351, 2.2421, 0.0000, 0.0718, 2.2935, -0.4744,  # PSEU_MEN
                               0.0133, 1.3303, 1.6877, 0.0086, 1.6216, 0.8192, 0.0428, 2.7965, -0.7328, 0.0854, 2.4388, -0.7630, # PICE_ENG
                               0.0239, 1.6827, 1.1878, 0.0117, 1.6398, 0.6524, 0.0285, 3.3764, -1.4395, 0.0769, 2.6834, -1.2484, # PICE_CON
                               0.0315, 1.8297, 0.8056, 0.0067, 2.6970, -0.3105, 0.0420, 2.0313, 0.0000, 0.0452, 2.4867, -0.4982, # ABIE_AMA
                               0.0051, 1.0697, 2.2748, 0.0009, 1.3061, 2.0109, 0.0131, 2.5760, 0.0000, 0.0224, 1.8368, 0.0000,   # ALNU_RUB
                               0.0051, 1.0697, 2.2748, 0.0009, 1.3061, 2.0109, 0.0131, 2.5760, 0.0000, 0.0224, 1.8368, 0.0000,   # POPU_TRI
                               0.0237, 2.5813, 0.0822, 0.0045, 1.2275, 1.5190, 0.0498, 1.9671, 0.0000, 0.0140, 3.1305, -0.9070,  # PICE_SIT
                               0.0220, 1.6469, 1.1714, 0.0061, 1.8603, 0.7693, 0.0265, 3.6747, -1.5958, 0.0509, 2.9909, -1.2271, # ABIE_LAT
                               0.0143, 1.9369, 1.0579, 0.0063, 2.0744, 0.6691, 0.0150, 2.9068, -0.6306, 0.0284, 1.6020, 0.0000,  # POPU_TRE
                               0.0113, 1.9332, 1.1125, 0.0019, 2.3356, 0.6371, 0.0609, 2.0021, 0.0000, 0.2656, 2.0107, -0.7963,  # TSUG_HET
                               0.0188, 1.3376, 1.5293, 0.0002, 2.4369, 1.1315, 0.0611, 1.9208, 0.0000, 0.1097, 1.5530, 0.0000,   # THUJ_PLI
                               0.0333, 2.0794, 0.6811, 0.0079, 1.9905, 0.6553, 0.0253, 3.1518, -0.9083, 0.1361, 2.2978, -1.0934, # BETU_PAP
                               0.0252, 1.7819, 1.0022, 0.0096, 1.6901, 0.7393, 0.0322, 2.8961, -0.9203, 0.1832, 2.4144, -1.0948, # PICE_GLA
                               0.0353, 2.0249, 0.7048, 0.0090, 1.8677, 0.7144, 0.0448, 2.6855, -0.5911, 0.0869, 1.8541, -0.5491, # GENH_SPP
                               0.0276, 1.6868, 1.0953, 0.0101, 1.8486, 0.5525, 0.0313, 2.9974, -1.0383, 0.1379, 2.3981, -1.0418, # GENC_SPP
                               0.0283, 1.8298, 0.9546, 0.0120, 1.6378, 0.7746, 0.0338, 2.6624, -0.5743, 0.1699, 2.3289, -1.1316) # GENA_APP
                    )


# PICE_MAR = Black Spruce (Picea mariana)
# PSEU_MEN = Douglas Fir (Pseudostuga menziesii)
# PICE_ENG = Engelman Spruce (Picea engelmannii)
# PINU_CON = Lodgepole Pine (Pinus contorta)
# ABIE_AMA = Pacific Silver Fir/Amabilis Fir (Abies amabilis)
# ALNU_RUB = Red Alder (Alnus rubra)
# POPU_TRI = Black Cottonwood (Populus trichocarpa)
# PICE_SIT = Sitka Spruce (Picea sitchensis)
# ABIE_LAS = Subalpine Fir (Abies lasiocarpa)
# POPU_TRE = Trembling Aspen (Populus tremuloides)
# TSUG_HET = Western Hemlock (Tsuga heterophylla)
# THUJ_PLI = Western Red Cedar (Thuja plicata)
# BETU_PAP = White/Paper Birch (Betula papyrifera)
# PICE_GLA = White Spruce (Picea glauca)
# GENH_SPP = All Hardwoods (Unidentified Hardwood)
# GENC_SPP = All Softwoods (Unidentified Softwood)
# GENA_APP = All Species (Unidentified Tree)

