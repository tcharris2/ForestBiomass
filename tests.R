
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
         eval = "ung_2",
         species = "LGTREE_NFI",
         dbh = "DBH",
         height = "HEIGHT",
         crown_cond = "CROWN_COND",
         appearance = "APPEARANCE",
         output = "carbon",
         decay = TRUE
)
