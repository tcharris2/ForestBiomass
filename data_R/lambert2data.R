# Model parameter estimates for the DBH-based set of equations for each species,
# for all hardwoods, for all softwoods, and for all species combined


LAMBERT_2 <- data.frame(SPECIES =  rep(c("ABIE_LAS", "ABIE_BAL", "POPU_BAL", "TILI_AME", "FAGU_GRA", "FRAX_NIG",
                                     "PRUN_SER", "PICE_MAR", "TSUG_CAN", "JUNI_VIR", "THUJ_OCC", "PINU_STR",
                                     "BETU_POP", "CARY_SPP", "OSTR_VIR", "PINU_BAN", "POPU_GRA", "PINU_CON",
                                     "FRAX_PEN", "ACER_RUB", "QUER_RUB", "PINU_RES", "PICE_RUB", "ACER_SAC",
                                     "ACER_SAH", "LARI_LAR", "POPU_TRE", "FRAX_AME", "BETU_PAP", "ULMU_AME",
                                     "QUER_ALB", "PICE_GLA", "BETU_ALL", "HARD_SPP", "SOFT_SPP", "ALL_SPP"), each = 12), 
                        COMPONENT =  c("WOOD", "WOOD", "WOOD", "BARK", "BARK", "BARK",
                                       "BRANCH", "BRANCH", "BRANCH", "FOLIAGE", "FOLIAGE", "FOLIAGE"),
                        BETA_NUM = c(1, 2, 3),
                        VALUES = c(0.0268, 1.7579, 0.9871, 0.0009, 1.4460, 1.8839, 0.0470, 2.9288, -1.1588, 0.0551, 1.7585, 0.0000, # ABIE_LAS
                                    0.0294, 1.8357, 0.8640, 0.0053, 2.0876, 0.5842, 0.0117, 3.5097, -1.3006, 0.1245, 2.5230, -1.1230, # ABIE_BAL
                                    0.0117, 1.7757, 1.2555, 0.0180, 1.8131, 0.5144, 0.0112, 3.0861, -0.7164, 0.0617, 1.8615, -0.5375, # POPU_BAL
                                    0.0168, 1.9844, 0.8989, 0.0057, 1.5881, 1.1472, 0.0039, 2.0084, 0.8588, 0.0147, 1.8300, 0.0000, # TILI_AME
                                    0.0432, 2.0378, 0.7000, 0.0049, 1.9057, 0.6770, 0.0355, 2.3749, 0.0000, 0.0452, 1.5567, 0.0000, # FAU_GRA
                                    0.0306, 2.1836, 0.5740, 0.0897, 2.2634, -0.5670, 0.0994, 2.1630, -0.4809, 0.0124, 1.0325, 0.8747, # FRAX_NIG
                                    0.0181, 1.7013, 1.3057, 0.0101, 1.5956, 0.9190, 0.0005, 2.8004, 0.8603, 0.1976, 1.4421, -0.5264, # PRUN_SER
                                    0.0309, 1.7527, 1.0014, 0.0115, 1.7405, 0.6589, 0.0380, 3.2558, -1.4218, 0.2048, 2.5754, -1.3704, # PICE_MAR
                                    0.0257, 1.9277, 0.8576, 0.0118, 1.9893, 0.4700, 0.0215, 2.6553, -0.4682, 0.1471, 2.0108, -0.6080, # TSUG_CAN
                                    0.0520, 1.7731, 0.7054, 0.0283, 1.7079, 0.0000, 0.0219, 2.3585, 0.0000, 0.2575, 2.5136, -1.5565, # JUNI_VIR
                                    0.0295, 1.7026, 0.9428, 0.0076, 1.7861, 0.6132, 0.0501, 2.5165, -0.8774, 0.0813, 2.2180, -0.7907, # THUJ_OCC
                                    0.0170, 1.7779, 1.1370, 0.0069, 1.6589, 0.9582, 0.0184, 3.1968, -1.0876, 0.0584, 2.2389, -0.5968, # PINU_STR
                                    0.0295, 1.9064, 0.9139, 0.0148, 1.8433, 0.5021, 0.0150, 3.0347, -0.7629, 0.0455, 2.6447, -1.4955, # BETU_POP
                                    0.0139, 1.5913, 1.5080, 0.0081, 1.4943, 1.1324, 0.0050, 3.04634, 0.0000, 0.0121, 2.0864, 0.0000, # CARY_SPP
                                    0.0083, 1.6534, 1.7479, 0.0012, 1.1486, 2.2903, 0.0009, 1.9152, 1.7769, 0.0247, 2.0056, 0.0000, # OSTR_VIR
                                    0.0199, 1.6883, 1.2456, 0.0141, 1.5994, 0.5957, 0.0185, 3.0584, -0.9816, 0.0325, 1.7879, 0.0000, # PINU_BAN
                                    0.0128, 2.0633, 0.9516, 0.0240, 2.3055, 0.0000, 0.0131, 3.1274, -0.8379, 0.0382, 2.1673, -0.6842, # POPU_GRA
                                    0.0202, 1.7179, 1.2078, 0.0099, 1.6049, 0.7456, 0.0440, 3.7190, -2.0399, 0.0785, 2.5377, -1.1213, # PINU_CON
                                    0.0224, 1.7845, 1.0660, 0.0219, 1.4190, 0.8963, 0.0176, 2.3313, 0.0000, 0.0761, 1.3077, 0.0000, # FRAX_PEN
                                    0.0315, 2.0342, 0.7485, 0.0283, 2.0907, 0.0000, 0.0225, 2.4106, 0.0000, 0.0571, 1.4898, 0.0000, # ACER_RUB
                                    0.0285, 1.8501, 1.0204, 0.0326, 1.8100, 0.4153, 0.0013, 3.0637, 0.3153, 0.0582, 1.5438, 0.0000, # QUER_RUB
                                    0.0106, 1.7725, 1.3285, 0.0277, 1.5192, 0.4645, 0.0125, 3.3865, -1.1939, 0.0731, 2.3439, -0.7378, # PINU_RES
                                    0.0143, 1.6441, 1.4065, 0.0274, 2.0188, 0.0000, 0.0005, 3.3136, 0.0000, 0.0106, 2.2709, 0.0000, # PICE_RUB
                                    0.0274, 1.7126, 1.1086, 0.0123, 1.8250, 0.5010, 0.0543, 3.7343, -1.6497, 6.6808, 2.1092, -2.1697, # ACER_SAC
                                    0.0301, 2.0313, 0.8171, 0.0103, 1.7111, 0.8509, 0.0661, 2.5940, -0.4933, 2.5019, 2.4527, -2.3008, # ACER_SAH
                                    0.0276, 1.6724, 1.1443, 0.0120, 1.7059, 0.5811, 0.0336, 3.1335, -1.1559, 0.1324, 2.1140, -0.8781, # LARI_LAR
                                    0.0142, 1.9389, 1.0572, 0.0063, 2.0819, 0.6617, 0.0137, 2.9270, -0.6221, 0.0270, 1.6183, 0.0000, # POPU_TRE
                                    0.0224, 1.7438, 1.1899, 0.0126, 1.6456, 0.7893, 0.0354, 2.3046, 0.0000, 0.0195, 1.0509, 0.7836, # FRAX_AME
                                    0.0338, 2.0702, 0.6876, 0.0080, 1.9754, 0.6659, 0.0257, 3.1754, -0.9417, 0.1415, 2.3074, -1.1189, # BETU_PAP
                                    0.0207, 2.2276, 0.6488, 0.0078, 2.4540, 0.0000, 0.0393, 2.1880, 0.0000, 0.0516, 1.4511, 0.0000, # ULMU_AME
                                    0.0442, 1.6818, 1.0310, 0.0308, 1.7479, 0.3504, 0.0022, 2.0165, 1.3953, 0.0053, 1.2822, 1.1323, # QUER_ALB
                                    0.0265, 1.7952, 0.9733, 0.0124, 1.6962, 0.6489, 0.0325, 2.8573, -0.9127, 0.2020, 2.3802, -1.1103, # PICE_GLA
                                    0.0259, 1.9044, 0.9715, 0.0069, 2.0834, 0.5371, 0.0325, 2.3851, 0.0000, 0.1683, 1.2764, 0.0000, # BETU_ALL
                                    0.0359, 2.0263, 0.6987, 0.0094, 1.8677, 0.6985, 0.0433, 2.6817, -0.5731, 0.0859, 1.8485, -0.5383, # HARD_SPP
                                    0.0284, 1.6894, 1.0857, 0.0100, 1.8463, 0.05616, 0.0301, 3.0028, -1.0520, 0.1554, 2.4021, -1.1043, # SOFT_SPP
                                    0.0348, 1.9325, 0.7829, 0.0139, 1.5429, 0.8189, 0.0346, 2.6706, -0.6033, 0.1822, 2.2864, -1.1203 # ALL_SPP
                        )
)




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
