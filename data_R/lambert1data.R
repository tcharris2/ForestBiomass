# Model parameter estimates for the DBH-based set of equations for each species,
# for all hardwoods, for all softwoods, and for all species combined

LAMBERT_1 <- data.frame(SPECIES = rep(c("ABIE_LAS", "ABIE_BAL", "POPU_BAL", "TILI_AME", "FAGU_GRA", "FRAX_NIG",
                                        "PRUN_SER", "PICE_MAR", "TSUG_CAN", "JUNI_VIR", "THUJ_OCC", "PINU_STR",
                                        "BETU_POP", "CARY_SPP", "OSTR_VIR", "PINU_BAN", "POPU_GRA", "PINU_CON",
                                        "FRAX_PEN", "ACER_RUB", "QUER_RUB", "PINU_RES", "PICE_RUB", "ACER_SAC",
                                        "ACER_SAH", "LARI_LAR", "POPU_TRE", "FRAX_AME", "BETU_PAP", "ULMU_AME",
                                        "QUER_ALB", "PICE_GLA", "BETU_ALL", "HARD_SPP", "SOFT_SPP", "ALL_SPP"), each = 8),
                        
                        COMPONENT = c("WOOD", "WOOD", "BARK", "BARK",
                                        "BRANCH", "BRANCH", "FOLIAGE", "FOLIAGE"),
                        BETA_NUM = c(1, 2),
                        VALUES = c(0.0528, 2.4309, 0.0108, 2.3976, 0.0121, 2.3519, 0.0251, 2.0389, # ABIE_LAS
                                    0.0534, 2.4030, 0.0115, 2.3484, 0.0070, 2.5406, 0.0840, 1.6695, # ABIE_BAL
                                    0.0510, 2.4529, 0.0297, 2.1131, 0.0120, 2.4165, 0.0276, 1.6215, # POPU_BAL
                                    0.0562, 2.4102, 0.0302, 2.0976, 0.0230, 2.2382, 0.0288, 1.6378, # TILI_AME
                                    0.1478, 2.2986, 0.0120, 2.2388, 0.0370, 2.3680, 0.0376, 1.6164, # FAGU_GRA
                                    0.0941, 2.3491, 0.0323, 2.0761, 0.0448, 1.9771, 0.0538, 1.3584, # FRAX_NIG
                                    0.3743, 1.9406, 0.0679, 1.8377, 0.0796, 2.0103, 0.0840, 1.2319, # PRUN_SER
                                    0.0477, 2.5147, 0.0153, 2.2429, 0.0278, 2.0839, 0.1648, 1.4143, # PICE_MAR
                                    0.0619, 2.3821, 0.0139, 2.3282, 0.0217, 2.2653, 0.0776, 1.6995, # TSUG_CAN
                                    0.1277, 1.9778, 0.0377, 1.6064, 0.0254, 2.2884, 0.0550, 1.8656, # JUNI_VIR
                                    0.0654, 2.2121, 0.0114, 2.1432, 0.0335, 1.9367, 0.0499, 1.7278, # THUJ_OCC
                                    0.0997, 2.2709, 0.0192, 2.2038, 0.0056, 2.6001, 0.0284, 1.9375, # PINU_STR
                                    0.0720, 2.3885, 0.0168, 2.2569, 0.0088, 2.5689, 0.0099, 1.8985, # BETU_POP
                                    0.2116, 2.2013, 0.0365, 2.1133, 0.0087, 2.8927, 0.0173, 1.9830, # CARY_SPP
                                    0.1929, 1.9672, 0.0671, 1.5911, 0.0278, 2.1336, 0.0293, 1.9502, # OSTR_VIR
                                    0.0804, 2.4041, 0.0184, 2.0703, 0.0079, 2.4155, 0.0389, 1.7290, # PINU_BAN
                                    0.0959, 2.3430, 0.0308, 2.2240, 0.0047, 2.6530, 0.0080, 2.0149, # POPU_GRA
                                    0.0475, 2.5437, 0.0186, 2.0807, 0.0198, 2.1287, 0.0432, 1.7166, # PINU_CON
                                    0.1571, 2.1817, 0.0416, 2.0509, 0.0177, 2.3370, 0.1041, 1.2185, # FRAX_PEN
                                    0.1014, 2.3448, 0.0291, 2.0893, 0.0175, 2.4846, 0.0515, 1.5198, # ACER_RUB
                                    0.1754, 2.1616, 0.0381, 2.0991, 0.0085, 2.7790, 0.0373, 1.6740, # QUER_RUB
                                    0.0564, 2.4465, 0.0188, 2.5027, 0.0033, 2.7515, 0.0212, 2.0690, # PINU_RES
                                    0.0989, 2.2814, 0.0220, 2.0908, 0.0005, 3.2750, 0.0066, 2.4213, # PICE_RUB
                                    0.2324, 2.1000, 0.0278, 2.0433, 0.0028, 3.1020, 0.1430, 1.2580, # ACER_SAC
                                    0.1315, 2.3129, 0.0631, 1.9241, 0.0330, 2.3741, 0.0393, 1.6930, # ACER_SAH
                                    0.0625, 2.4475, 0.0174, 2.1109, 0.0196, 2.2652, 0.0801, 1.4875, # LARI_LAR
                                    0.0605, 2.4750, 0.0168, 2.3949, 0.0080, 2.5214, 0.0261, 1.6304, # POPU_TRE
                                    0.1861, 2.1665, 0.0406, 1.9946, 0.0461, 2.2291, 0.1106, 1.2277, # FRAX_AME
                                    0.0593, 2.5026, 0.0135, 2.4053, 0.0135, 2.5532, 0.0546, 1.6351, # BETU_PAP
                                    0.0402, 2.5804, 0.0073, 2.4859, 0.0401, 2.1826, 0.0750, 1.3426, # ULMU_AME
                                    0.0762, 2.3335, 0.0338, 1.9845, 0.0113, 2.6211, 0.0188, 1.7881, # QUER_ALB
                                    0.0359, 2.5775, 0.0116, 2.3022, 0.0283, 2.0823, 0.1601, 1.4670, # PICE_GLA
                                    0.1932, 2.1569, 0.0192, 2.2475, 0.0305, 2.4044, 0.1119, 1.3973, # BETU_ALL
                                    0.0871, 2.3702, 0.0241, 2.1969, 0.0167, 2.4807, 0.0390, 1.6229, # HARD_SPP
                                    0.0648, 2.3927, 0.0162, 2.1959, 0.0156, 2.2916, 0.0861, 1.6261, # SOFT_APP
                                    0.0787, 2.3702, 0.0185, 2.2159, 0.0230, 2.2678, 0.0767, 1.5720 # ALL_SPP
                        ))




# ABIE_LAS = subapline fir (Abies lasiocarpa)
# ABIE_BAL = balsam fir (Abies balsamea)
# POPU_BAL = balsam poplar (Populus balsamifera)
# TILI_AME = basswood (Tilia americana)
# FAGU_GRA = Beech (Fagus grandifolia)
# FRAX_NIG = Black ash (Fraxinus nigra)
# PRUN_SER = Black cherry (Prunus serotina)
# PICE_MAR = Black spruce (Picea mariana)
# TSUG_CAN = Eastern hemlock (Tsuga canadensis)
# JUNI_VIR = Eastern redcedar (Juniperus viginiana)
# THUJ_OCC = Eastern white-cedar (Thuja occidentalis)
# PINU_STR = Eastern white pine (Pinus strobus)
# BETU_POP = Grey birch (Betula populifolia)
# CARY_SPP = Hockory (Carya spp.)
# OSTR_VIR = Hop-hornbeam (Ostrya virginiana)
# PINU_BAN = Jack pine (Pinus bankisana)
# POPU_GRA = Largetooth aspen (Populus grandidentata)
# PINU_CON = Lodgepole pine (Pinus contorta)
# FRAX_PEN = Red ash (Fraxinus pennsylvanica)
# ACER_RUB = Red maple (Acer rubrum)
# QUER_RUB = Red oak (Quercus rubra)
# PINU_RES = Red pine (Pinus resinosa)
# PICE_RUB = Red spruce (Picea rubens)
# ACER_SAC = Silver maple (Acer saccharinum)
# ACER_SAH = Sugar maple (Acer saccharum)
# LARI_LAR = Tamarack larch (Larix laricina)
# POPU_TRE = Trembling aspen (Populus tremuloides)
# FRAX_AME = White ash (Fraxinus americana)
# BETU_PAP = White birch (Betula papyifera)
# ULMU_AME = White elm (Ulmus americana)
# QUER_ALB = White oak (Quercus alba)
# PICE_GLA = White spruce (Picea glauca)
# BETU_ALL = Yellow birch (Betula alleghaniensis) (Betula lutea)
# HARD_SPP = Hardwoods
# SOFT_SPP = Softwoods
# ALL_SPP
