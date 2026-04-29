# Model parameter estimates for the DBH-based set of equations for each species,
# for all hardwoods, for all softwoods, and for all species combined


UNG_1 <- data.frame(SPECIES = rep(c("PICE_MAR", "PSEU_MEN", "PICE_ENG", "PINU_CON", "ABIE_AMA", "ALNU_RUB",
                                    "POPU_TRI", "PICE_SIT", "ABIE_LAS", "POPU_TRE", "TSUG_HET", "THUJ_PLI",
                                    "BETU_PAP", "PICE_GLA", "GENH_SPP", "GENC_SPP", "GENA_SPP"), each = 8),
                    #beta = beta,
                    COMPONENT = c("WOOD", "WOOD", "BARK", "BARK",
                                  "BRANCH", "BRANCH", "FOLIAGE", "FOLIAGE"),
                    BETA_NUM = c(1, 2),
                    VALUE =  c(0.0494, 2.5025, 0.0148, 2.2494, 0.0291, 2.0751, 0.1631, 1.4222, # PICE_MAR
                               0.0204, 2.6974, 0.0069, 2.5462, 0.0404, 2.1388, 0.1233, 1.6636, # PSEU_MEN
                               0.0223, 2.7169, 0.0118, 2.2733, 0.0336, 2.2123, 0.0683, 1.8022, # PICE_ENG
                               0.0323, 2.6825, 0.0144, 2.1768, 0.0209, 2.1772, 0.0584, 1.6432, # PINU_CON
                               0.0424, 2.4289, 0.0057, 2.4786, 0.0322, 2.1313, 0.0645, 1.9400, # ABIE_AMA
                               0.0460, 2.4312, 0.0074, 2.4442, 0.0086, 2.7326, 0.0114, 2.0860, # ALNU_RUB
                               0.0460, 2.4312, 0.0074, 2.4442, 0.0086, 2.7326, 0.0114, 2.0860, # POPU_TRI
                               0.0302, 2.5776, 0.0066, 2.4433, 0.0739, 1.8342, 0.0157, 2.3113, # PICE_SIT
                               0.0250, 2.6378, 0.0061, 2.5275, 0.0178, 2.4255, 0.0416, 2.0130, # ABIE_LAS
                               0.0608, 2.4735, 0.0159, 2.4123, 0.0082, 2.5139, 0.0235, 1.6656, # POPU_TRE
                               0.0141, 2.8668, 0.0025, 2.8062, 0.0703, 1.9547, 0.1676, 1.4339, # TSUG_HET
                               0.0111, 2.8027, 0.0003, 3.2721, 0.1158, 1.7196, 0.1233, 1.5152, # THUJ_PLI
                               0.0604, 2.4959, 0.0140, 2.3923, 0.0147, 2.5227, 0.0591, 1.6036, # BETU_PAP
                               0.0334, 2.5980, 0.0114, 2.3057, 0.0302, 2.0927, 0.1515, 1.5012, # PICE_GLA
                               0.0864, 2.3715, 0.0226, 2.2151, 0.0186, 2.4462, 0.0385, 1.6255, # GENH_SPP
                               0.0564, 2.4347, 0.0153, 2.2110, 0.0194, 2.2408, 0.0935, 1.6106, # GENC_SPP
                               0.0741, 2.3875, 0.0182, 2.2181, 0.0227, 2.2797, 0.0764, 1.5861) # GENA_SPP
                    )


COMPONENT <-  c("WOOD", "WOOD", "BARK", "BARK",
                "BRANCH", "BRANCH", "FOLIAGE", "FOLIAGE")

BETA_NUM <- c(1, 2)

VALUE <- c(0.0494, 2.5025, 0.0148, 2.2494, 0.0291, 2.0751, 0.1631, 1.4222, # PICE_MAR
           0.0204, 2.6974, 0.0069, 2.5462, 0.0404, 2.1388, 0.1233, 1.6636, # PSEU_MEN
           0.0223, 2.7169, 0.0118, 2.2733, 0.0336, 2.2123, 0.0683, 1.8022, # PICE_ENG
           0.0323, 2.6825, 0.0144, 2.1768, 0.0209, 2.1772, 0.0584, 1.6432, # PINU_CON
           0.0424, 2.4289, 0.0057, 2.4786, 0.0322, 2.1313, 0.0645, 1.9400, # ABIE_AMA
           0.0460, 2.4312, 0.0074, 2.4442, 0.0086, 2.7326, 0.0114, 2.0860, # ALNU_RUB
           0.0460, 2.4312, 0.0074, 2.4442, 0.0086, 2.7326, 0.0114, 2.0860, # POPU_TRI
           0.0302, 2.5776, 0.0066, 2.4433, 0.0739, 1.8342, 0.0157, 2.3113, # PICE_SIT
           0.0250, 2.6378, 0.0061, 2.5275, 0.0178, 2.4255, 0.0416, 2.0130, # ABIE_LAS
           0.0608, 2.4735, 0.0159, 2.4123, 0.0082, 2.5139, 0.0235, 1.6656, # POPU_TRE
           0.0141, 2.8668, 0.0025, 2.8062, 0.0703, 1.9547, 0.1676, 1.4339, # TSUG_HET
           0.0111, 2.8027, 0.0003, 3.2721, 0.1158, 1.7196, 0.1233, 1.5152, # THUJ_PLI
           0.0604, 2.4959, 0.0140, 2.3923, 0.0147, 2.5227, 0.0591, 1.6036, # BETU_PAP
           0.0334, 2.5980, 0.0114, 2.3057, 0.0302, 2.0927, 0.1515, 1.5012, # PICE_GLA
           0.0864, 2.3715, 0.0226, 2.2151, 0.0186, 2.4462, 0.0385, 1.6255, # GENH_SPP
           0.0564, 2.4347, 0.0153, 2.2110, 0.0194, 2.2408, 0.0935, 1.6106, # GENC_SPP
           0.0741, 2.3875, 0.0182, 2.2181, 0.0227, 2.2797, 0.0764, 1.5861) # GENA_SPP

SPECIES <- c("PICE_MAR", "PSEU_MEN", "PICE_ENG", "PINU_CON", "ABIE_AMA", "ALNU_RUB",
             "POPU_TRI", "PICE_SIT", "ABIE_LAS", "POPU_TRE", "TSUG_HET", "THUJ_PLI",
             "BETU_PAP", "PICE_GLA", "GENH_SPP", "GENC_SPP", "GENA_SPP")


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

