# Getting Started with ForestBiomass

``` r

library(ForestBiomass)
```

ForestBiomass calculates above-ground and below-ground tree biomass
using published allometric equations. This vignette walks through the
most common workflow: estimating total above-ground biomass with
[`treeCalc()`](https://tcharris2.github.io/ForestBiomass/reference/treeCalc.md),
choosing output units, applying decay corrections, and chaining into
[`rootCalc()`](https://tcharris2.github.io/ForestBiomass/reference/rootCalc.md)
for root biomass.

## Your data

[`treeCalc()`](https://tcharris2.github.io/ForestBiomass/reference/treeCalc.md)
requires a data frame with one row per tree. The package includes
`sample_trees`, a six-tree dataset covering common BC species:

``` r

sample_trees
#>    SPECIES  DBH HEIGHT APPEARANCE CROWN_COND
#> 1 PSEU_MEN 32.4   22.1          1          1
#> 2 PINU_CON 18.7   14.5          1          2
#> 3 TSUG_HET 14.2   11.8          3          3
#> 4 POPU_TRE 27.6   20.3          2          1
#> 5 PICE_MAR  9.8    8.4          5          4
#> 6 PICE_GLA 41.3   28.7          1          1
```

The required columns are:

| Column | Content | Notes |
|----|----|----|
| Species | NFI code (e.g., `"PSEU_MEN"`) | See [`?UNG_1`](https://tcharris2.github.io/ForestBiomass/reference/UNG_1.md) for valid Ung codes |
| DBH | Diameter at breast height (cm) | Required for all equation sets |
| Height | Total tree height (m) | Required for `ung_2` and `lambert_2` |
| Appearance | Appearance code (1-7) | Required when `decay = TRUE` |
| Crown condition | Crown condition code (1-5) | Required for Ung and Lambert pathways |

## Estimating total above-ground biomass

[`treeCalc()`](https://tcharris2.github.io/ForestBiomass/reference/treeCalc.md)
with `eval = "ung_2"` (the default) uses Ung et al. (2008) equations for
BC species, fitting biomass as a function of both DBH and height.

``` r

agb <- treeCalc(
  data       = sample_trees,
  eval       = "ung_2",
  species    = "SPECIES",
  dbh        = "DBH",
  height     = "HEIGHT",
  appearance = "APPEARANCE",
  crown_cond = "CROWN_COND",
  output     = "biomass",
  decay      = TRUE
)
#> Output: biomass (kg)
#> Species specified decay reduction factor applied (Harmon et al., 2011)
agb
#> [1] 452.36300 106.23299  39.83234 300.01647  20.34684 721.02620
```

Each value is the total above-ground biomass for one tree in kilograms.
`decay = TRUE` applies a species-specific reduction for standing dead or
downed wood (Harmon et al., 2011). For live-tree inventories, use
`decay = FALSE`.

## Output options

The `output` argument controls units and whether the result is carbon:

``` r

# Per-tree biomass (kg) — default
suppressMessages(
  treeCalc(sample_trees, eval = "ung_2", species = "SPECIES",
           dbh = "DBH", height = "HEIGHT", appearance = "APPEARANCE",
           crown_cond = "CROWN_COND", output = "biomass", decay = FALSE)
)
#> [1] 452.36300 106.23299  44.25815 300.01647  20.53162 721.02620

# Per-tree carbon (kg) — biomass × 0.5
suppressMessages(
  treeCalc(sample_trees, eval = "ung_2", species = "SPECIES",
           dbh = "DBH", height = "HEIGHT", appearance = "APPEARANCE",
           crown_cond = "CROWN_COND", output = "carbon", decay = FALSE)
)
#> [1] 226.18150  53.11649  22.12908 150.00823  10.26581 360.51310

# Stand-level biomass (Mg/ha) — requires plot_radius
suppressMessages(
  treeCalc(sample_trees, eval = "ung_2", species = "SPECIES",
           dbh = "DBH", height = "HEIGHT", appearance = "APPEARANCE",
           crown_cond = "CROWN_COND", output = "biomass Mg/ha",
           decay = FALSE, plot_radius = 11.28)
)
#> [1] 11.3090750  2.6558247  1.1064539  7.5004117  0.5132905 18.0256551

# Stand-level carbon (Mg/ha)
suppressMessages(
  treeCalc(sample_trees, eval = "ung_2", species = "SPECIES",
           dbh = "DBH", height = "HEIGHT", appearance = "APPEARANCE",
           crown_cond = "CROWN_COND", output = "carbon Mg/ha",
           decay = FALSE, plot_radius = 11.28)
)
#> [1] 5.6545375 1.3279123 0.5532269 3.7502058 0.2566453 9.0128275
```

The `plot_radius` argument controls the per-hectare expansion factor:

| Plot radius (m) | Trees per hectare |
|-----------------|-------------------|
| 3.99            | 200               |
| 5.64            | 100               |
| 7.98            | 50                |
| 11.28           | 25                |

## Choosing an equation set

Five `eval` options are available:

| `eval` | Source | Inputs needed | Best for |
|----|----|----|----|
| `"ung_1"` | Ung et al. 2008 | DBH | BC — DBH only |
| `"ung_2"` | Ung et al. 2008 | DBH + height | BC — DBH and height (default) |
| `"lambert_1"` | Lambert et al. 2005 | DBH | Eastern Canada — DBH only |
| `"lambert_2"` | Lambert et al. 2005 | DBH + height | Eastern Canada — DBH and height |
| `"jenkins"` | Jenkins et al. 2003 | DBH | Any region — DBH only |

`"ung_1"` and `"ung_2"` use the same 17 BC species. Use `"lambert_1"` or
`"lambert_2"` for Eastern Canada species (see
[`?LAMBERT_1`](https://tcharris2.github.io/ForestBiomass/reference/LAMBERT_1.md)).
The `"jenkins"` pathway covers all species in `JENKINS_GROUPS` and
requires no height or crown condition measurement.

## Decay class reduction

When `decay = TRUE` (the default), a species-specific decay class
reduction factor is applied from Harmon et al. (2011). Trees with
appearance code 1 (freshly dead / recently fallen) receive no reduction;
higher codes apply increasing reductions. Live trees should use
`decay = FALSE`.

``` r

no_decay   <- suppressMessages(
  treeCalc(sample_trees, eval = "ung_2", species = "SPECIES",
           dbh = "DBH", height = "HEIGHT", appearance = "APPEARANCE",
           crown_cond = "CROWN_COND", output = "biomass", decay = FALSE)
)
with_decay <- suppressMessages(
  treeCalc(sample_trees, eval = "ung_2", species = "SPECIES",
           dbh = "DBH", height = "HEIGHT", appearance = "APPEARANCE",
           crown_cond = "CROWN_COND", output = "biomass", decay = TRUE)
)

data.frame(
  species    = sample_trees$SPECIES,
  appearance = sample_trees$APPEARANCE,
  no_decay   = round(no_decay,   1),
  with_decay = round(with_decay, 1),
  pct_reduction = round((1 - with_decay / no_decay) * 100, 1)
)
#>    species appearance no_decay with_decay pct_reduction
#> 1 PSEU_MEN          1    452.4      452.4           0.0
#> 2 PINU_CON          1    106.2      106.2           0.0
#> 3 TSUG_HET          3     44.3       39.8          10.0
#> 4 POPU_TRE          2    300.0      300.0           0.0
#> 5 PICE_MAR          5     20.5       20.3           0.9
#> 6 PICE_GLA          1    721.0      721.0           0.0
```

## Using the Jenkins pathway

When height or crown condition are unavailable, `eval = "jenkins"`
estimates total above-ground biomass directly from DBH alone:

``` r

treeCalc(
  data       = sample_trees,
  eval       = "jenkins",
  species    = "SPECIES",
  dbh        = "DBH",
  appearance = "APPEARANCE",
  output     = "biomass",
  decay      = TRUE
)
#> Output: biomass (kg)
#> Species specified decay reduction factor applied (Harmon et al., 2011)
#> [1] 527.67476  96.13723  51.41830 301.63899  25.45366 735.73324
```

## Estimating root biomass

[`rootCalc()`](https://tcharris2.github.io/ForestBiomass/reference/rootCalc.md)
applies Li et al. (2003) root equations to a pre-computed above-ground
biomass column. It requires the above-ground biomass to be in Mg/ha (or
kg with a `plot_radius` for conversion).

``` r

sample_trees$AGB <- suppressMessages(
  treeCalc(sample_trees, eval = "ung_2", species = "SPECIES",
           dbh = "DBH", height = "HEIGHT", appearance = "APPEARANCE",
           crown_cond = "CROWN_COND", output = "biomass Mg/ha",
           decay = TRUE, plot_radius = 11.28)
)

rootCalc(
  data      = sample_trees,
  biomass   = "AGB",
  species   = "SPECIES",
  units     = "Mg/ha",
  root_type = "total",
  output    = "biomass Mg/ha"
)
#> Input units: Mg/ha
#> Output: biomass Mg/ha
#> Root type: total
#> [1] 2.5106147 0.5895931 0.2210695 5.4416869 0.1129249 4.0016954
```

Fine and coarse root fractions can be returned separately:

``` r

fine   <- suppressMessages(
  rootCalc(sample_trees, biomass = "AGB", species = "SPECIES",
           units = "Mg/ha", root_type = "fine")
)
coarse <- suppressMessages(
  rootCalc(sample_trees, biomass = "AGB", species = "SPECIES",
           units = "Mg/ha", root_type = "coarse")
)
total  <- suppressMessages(
  rootCalc(sample_trees, biomass = "AGB", species = "SPECIES",
           units = "Mg/ha", root_type = "total")
)

data.frame(
  species = sample_trees$SPECIES,
  fine    = round(fine,   3),
  coarse  = round(coarse, 3),
  total   = round(total,  3)
)
#>    species  fine coarse total
#> 1 PSEU_MEN 0.945  1.565 2.511
#> 2 PINU_CON 0.244  0.346 0.590
#> 3 TSUG_HET 0.093  0.128 0.221
#> 4 POPU_TRE 1.782  3.660 5.442
#> 5 PICE_MAR 0.048  0.065 0.113
#> 6 PICE_GLA 1.402  2.599 4.002
```
