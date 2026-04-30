
trees_data <- read.csv("NFI_data_example.csv")

# Wood check 
woodCalculator(data = trees_data, method = UNG_1, output = "biomass",
               dbh = "DBH", species = "LGTREE_NFI",
               func = ungEqn1, decay = FALSE #, height = "HEIGHT" #, appearance = "APPEARANCE"
               )



do.call(ForestBiomass::woodCalculator, list(data = trees_data, method = UNG_2, output = "biomass",
                                              dbh = "DBH", height = "HEIGHT", species = "LGTREE_NFI",
                                              func = ungEqn2, appearance = "APPEARANCE"))

trees_data1 <- trees_data
trees_data1$DBH <- as.character(trees_data1$DBH)

woodCalc(data = trees_data,
         eval = "ung_2",
         species = "LGTREE_NFI",
         dbh = "DBH",
         height = "HEIGHT",
         appearance = "APPEARANCE",
         output = "biomass",
         decay = TRUE
)


# branch check
branchCalculator(data = trees_data, method = UNG_2, output = "biomass",
                 dbh = "DBH", height = "HEIGHT", species = "LGTREE_NFI",
                 crown_cond = "CROWN_COND", appearance = "APPEARANCE",
                 func = ungEqn2, decay = TRUE)

branchCalc(data = trees_data,
           eval = "ung_2",
           species = "LGTREE_NFI",
           dbh = "DBH",
           height = "HEIGHT",
           crown_cond = "CROWN_COND",
           appearance = "APPEARANCE",
           output = "biomass",
           decay = FALSE
)

treeCalc(data = trees_data,
         eval = "ung_1",
         species = "LGTREE_NFI",
         dbh = "DBH",
         height = "HEIGHT",
         crown_cond = "CROWN_COND",
         appearance = "APPEARANCE",
         output = "carbon",
         decay = FALSE
)
?treeCalc

?rootCalc

trees_data$tree_biomass <- treeCalc(data = trees_data,
         eval = "ung_1",
         species = "LGTREE_NFI",
         dbh = "DBH",
         height = "HEIGHT",
         crown_cond = "CROWN_COND",
         appearance = "APPEARANCE",
         output = "biomass",
         decay = FALSE
)

# rootCalc check — units = "kg", all root_type options
rootCalc(data = trees_data,
         species = "LGTREE_NFI",
         biomass = "tree_biomass",
         units = "kg",
         plot_radius = 3.99,
         root_type = "total")

rootCalc(data = trees_data,
         species = "LGTREE_NFI",
         biomass = "tree_biomass",
         units = "kg",
         plot_radius = 3.99,
         root_type = "fine")

rootCalc(data = trees_data,
         species = "LGTREE_NFI",
         biomass = "tree_biomass",
         units = "kg",
         plot_radius = 3.99,
         root_type = "coarse")

# rootCalc check — units = "Mg/ha" (pre-computed AGB in Mg/ha)
trees_data$tree_biomass_Mgha <- treeCalc(data = trees_data,
         eval = "ung_1",
         species = "LGTREE_NFI",
         dbh = "DBH",
         height = "HEIGHT",
         crown_cond = "CROWN_COND",
         appearance = "APPEARANCE",
         output = "biomass Mg/ha",
         decay = FALSE)

rootCalc(data = trees_data,
         species = "LGTREE_NFI",
         biomass = "tree_biomass_Mgha",
         units = "Mg/ha",
         root_type = "total")

rootCalc(data = trees_data,
         species = "LGTREE_NFI",
         biomass = "tree_biomass_Mgha",
         units = "Mg/ha",
         root_type = "fine")

rootCalc(data = trees_data,
         species = "LGTREE_NFI",
         biomass = "tree_biomass_Mgha",
         units = "Mg/ha",
         root_type = "coarse")

# rootCalc check — carbon output
rootCalc(data = trees_data,
         species = "LGTREE_NFI",
         biomass = "tree_biomass_Mgha",
         units = "Mg/ha",
         output = "carbon Mg/ha")

# rootCalc error checks
stopifnot(inherits(tryCatch(
  rootCalc(data = trees_data, species = "LGTREE_NFI",
           biomass = "tree_biomass", units = "kg"),
  error = function(e) e), "error"))                       # missing plot_radius

stopifnot(inherits(tryCatch(
  rootCalc(data = trees_data, species = "LGTREE_NFI",
           biomass = "tree_biomass_Mgha", units = "Mg/ha", root_type = "stem"),
  error = function(e) e), "error"))                       # invalid root_type

stopifnot(inherits(tryCatch(
  rootCalc(data = trees_data, species = "LGTREE_NFI",
           biomass = "tree_biomass_Mgha", units = "tonnes"),
  error = function(e) e), "error"))                       # invalid units

# jenkinsRatio check — structure and value sanity
ratios <- jenkinsRatio(data = trees_data, dbh = "DBH", species = "LGTREE_NFI")

stopifnot(is.list(ratios))
stopifnot(identical(names(ratios), c("foliage", "coarse_roots", "stem_bark", "stem_wood")))
stopifnot(all(sapply(ratios, length) == nrow(trees_data)))
stopifnot(all(sapply(ratios, is.numeric)))
stopifnot(all(sapply(ratios, function(x) all(x > 0))))   # all ratios positive

# jenkinsRatio error checks
trees_data_chr <- trees_data
trees_data_chr$DBH <- as.character(trees_data_chr$DBH)
stopifnot(inherits(tryCatch(
  jenkinsRatio(data = trees_data_chr, dbh = "DBH", species = "LGTREE_NFI"),
  error = function(e) e), "error"))                       # non-numeric DBH

trees_data_bad <- trees_data
trees_data_bad$LGTREE_NFI[1] <- "FAKE_SPP"
stopifnot(inherits(tryCatch(
  jenkinsRatio(data = trees_data_bad, dbh = "DBH", species = "LGTREE_NFI"),
  error = function(e) e), "error"))                       # species not in SPECIES_CLASS
