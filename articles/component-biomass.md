# Component Biomass

``` r

library(ForestBiomass)
```

[`treeCalc()`](https://tcharris2.github.io/ForestBiomass/reference/treeCalc.md)
returns total above-ground biomass by summing four components: wood
(stem), bark, branches, and foliage. Each component can also be computed
independently. This is useful when you need allocation patterns, want to
exclude a component for a particular tree type (e.g., no foliage on a
snag), or need per-component carbon accounting.

## Individual component functions

All four functions share the same argument structure as
[`treeCalc()`](https://tcharris2.github.io/ForestBiomass/reference/treeCalc.md).

``` r

wood <- woodCalc(
  data    = sample_trees, eval = "ung_2",
  species = "SPECIES", dbh = "DBH", height = "HEIGHT",
  output  = "biomass", decay = FALSE
)
#> Output: biomass (kg)

bark <- suppressMessages(barkCalc(
  data    = sample_trees, eval = "ung_2",
  species = "SPECIES", dbh = "DBH", height = "HEIGHT",
  output  = "biomass", decay = FALSE
))

branch <- suppressMessages(branchCalc(
  data       = sample_trees, eval = "ung_2",
  species    = "SPECIES",    dbh = "DBH", height = "HEIGHT",
  crown_cond = "CROWN_COND", output = "biomass", decay = FALSE
))

foliage <- suppressMessages(foliageCalc(
  data       = sample_trees, eval = "ung_2",
  species    = "SPECIES",    dbh = "DBH", height = "HEIGHT",
  crown_cond = "CROWN_COND", output = "biomass", decay = FALSE
))
```

Summing the four components reproduces the
[`treeCalc()`](https://tcharris2.github.io/ForestBiomass/reference/treeCalc.md)
result exactly:

``` r

agb <- suppressMessages(
  treeCalc(sample_trees, eval = "ung_2", species = "SPECIES",
           dbh = "DBH", height = "HEIGHT", crown_cond = "CROWN_COND",
           output = "biomass", decay = FALSE)
)
all.equal(wood + bark + branch + foliage, agb)
#> [1] TRUE
```

Component proportions vary by species and tree size:

``` r

total <- wood + bark + branch + foliage
data.frame(
  species = sample_trees$SPECIES,
  wood_pct    = round(wood    / total * 100, 1),
  bark_pct    = round(bark    / total * 100, 1),
  branch_pct  = round(branch  / total * 100, 1),
  foliage_pct = round(foliage / total * 100, 1)
)
#>    species wood_pct bark_pct branch_pct foliage_pct
#> 1 PSEU_MEN     60.2     10.3       18.9        10.6
#> 2 PINU_CON     74.4      7.7       11.2         6.6
#> 3 TSUG_HET     67.2     10.2       14.0         8.7
#> 4 POPU_TRE     71.2     15.3       11.6         1.9
#> 5 PICE_MAR     70.0     12.4        7.8         9.8
#> 6 PICE_GLA     76.6      8.6        9.7         5.1
```

## Adjusting for partial bark loss

[`barkCalc()`](https://tcharris2.github.io/ForestBiomass/reference/barkCalc.md)
accepts an optional `rem_bark` column (percentage remaining, 0-100).
This scales bark biomass proportionally and is useful for trees with
beetle kill, fire scorch, or logging damage.

``` r

sample_trees$REM_BARK <- c(100, 100, 80, 60, 20, 100)

full_bark <- suppressMessages(
  barkCalc(sample_trees, eval = "ung_2", species = "SPECIES",
           dbh = "DBH", height = "HEIGHT", output = "biomass", decay = FALSE)
)
partial_bark <- suppressMessages(
  barkCalc(sample_trees, eval = "ung_2", species = "SPECIES",
           dbh = "DBH", height = "HEIGHT", rem_bark = "REM_BARK",
           output = "biomass", decay = FALSE)
)

data.frame(
  species  = sample_trees$SPECIES,
  rem_bark = sample_trees$REM_BARK,
  full_kg  = round(full_bark,    2),
  adj_kg   = round(partial_bark, 2)
)
#>    species rem_bark full_kg adj_kg
#> 1 PSEU_MEN      100   46.44  46.44
#> 2 PINU_CON      100    8.16   8.16
#> 3 TSUG_HET       80    4.50   3.60
#> 4 POPU_TRE       60   46.05  27.63
#> 5 PICE_MAR       20    2.54   0.51
#> 6 PICE_GLA      100   61.83  61.83
```

## Jenkins component ratios

[`jenkinsRatio()`](https://tcharris2.github.io/ForestBiomass/reference/jenkinsRatio.md)
decomposes total above-ground biomass into four component proportions
using Jenkins et al. (2003) equations. It requires only DBH and species
— no height or crown condition. Species are classified as softwood or
hardwood internally.

``` r

ratios <- jenkinsRatio(sample_trees, dbh = "DBH", species = "SPECIES")
#> Output: component ratios (foliage, coarse_roots, stem_bark, stem_wood)
str(ratios)
#> List of 4
#>  $ foliage     : num [1:6] 0.0596 0.0659 0.0711 0.0209 0.082 ...
#>  $ coarse_roots: num [1:6] 0.214 0.217 0.22 0.19 0.224 ...
#>  $ stem_bark   : num [1:6] 0.118 0.115 0.113 0.126 0.109 ...
#>  $ stem_wood   : num [1:6] 0.651 0.625 0.606 0.605 0.572 ...
```

Each element is a vector of ratios (one per tree). The Jenkins equations
are fit independently per component, so the four components sum to
approximately 1 rather than exactly 1:

``` r

wood_type <- SPECIES_CLASS$WOOD_TYPE[
  match(sample_trees$SPECIES, SPECIES_CLASS$SPECIES)
]

data.frame(
  species     = sample_trees$SPECIES,
  wood_type   = wood_type,
  foliage     = round(ratios$foliage,      3),
  coarse_root = round(ratios$coarse_roots, 3),
  stem_bark   = round(ratios$stem_bark,    3),
  stem_wood   = round(ratios$stem_wood,    3),
  check_sum   = round(ratios$foliage + ratios$coarse_roots +
                        ratios$stem_bark + ratios$stem_wood, 3)
)
#>    species wood_type foliage coarse_root stem_bark stem_wood check_sum
#> 1 PSEU_MEN  softwood   0.060       0.214     0.118     0.651     1.043
#> 2 PINU_CON  softwood   0.066       0.217     0.115     0.625     1.023
#> 3 TSUG_HET  softwood   0.071       0.220     0.113     0.606     1.010
#> 4 POPU_TRE  hardwood   0.021       0.190     0.126     0.605     0.941
#> 5 PICE_MAR  softwood   0.082       0.224     0.109     0.572     0.988
#> 6 PICE_GLA  softwood   0.058       0.213     0.119     0.659     1.049
```

Multiply the ratios by a Jenkins total biomass estimate to get component
values. Note that `coarse_root` here is a Jenkins-derived estimate and
uses different equations than
[`rootCalc()`](https://tcharris2.github.io/ForestBiomass/reference/rootCalc.md),
which applies Li et al. (2003):

``` r

jenkins_total <- suppressMessages(
  treeCalc(sample_trees, eval = "jenkins", species = "SPECIES",
           dbh = "DBH", output = "biomass", decay = FALSE)
)

data.frame(
  species     = sample_trees$SPECIES,
  stem_wood   = round(ratios$stem_wood    * jenkins_total, 1),
  stem_bark   = round(ratios$stem_bark    * jenkins_total, 1),
  foliage     = round(ratios$foliage      * jenkins_total, 1),
  coarse_root = round(ratios$coarse_roots * jenkins_total, 1)
)
#>    species stem_wood stem_bark foliage coarse_root
#> 1 PSEU_MEN     343.5      62.5    31.4       113.0
#> 2 PINU_CON      60.1      11.1     6.3        20.9
#> 3 TSUG_HET      34.6       6.5     4.1        12.6
#> 4 POPU_TRE     182.4      37.9     6.3        57.3
#> 5 PICE_MAR      14.7       2.8     2.1         5.8
#> 6 PICE_GLA     484.7      87.8    42.6       156.8
```
