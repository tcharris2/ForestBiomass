
<!-- README.md is generated from README.Rmd. Please edit that file -->

<img src="man/figures/Designer2.png" alt="" width="433px" style="display: block; margin: auto;" />

# ForestBiomass

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

**ForestBiomass** is an R package for estimating tree biomass and carbon
in Canadian temperate forests. It implements hierarchical allometric
equations at the component level (wood, bark, branches, foliage) and
supports total above-ground and below-ground biomass estimation. Decay
class reduction factors can be applied to standing dead wood.

## Scientific Sources

***When using this package ensure that the the authors of the
allometeric equations are properly cited***

| Equations | Reference | Coverage |
|----|----|----|
| Ung et al. (2008) | *Canadian Journal of Forest Research* | BC and national species |
| Lambert et al. (2005) | *Canadian Journal of Forest Research* | Eastern Canada species |
| Jenkins et al. (2003) | *Forest Science* 49(1): 12–35 | National-scale US estimates |
| Li et al. (2003) | *Canadian Journal of Forest Research* 33(1): 126–136 | Root biomass |
| Harmon et al. (2011) | Appendix D | Decay class reduction factors |

## Installation

``` r
# install.packages("devtools")
devtools::install_github("tcharris2/ForestBiomass")
```

## Quick Start

``` r
library(ForestBiomass)

# Use the built-in sample dataset
head(sample_trees)

# Total above-ground biomass (Ung et al. 2008, DBH only)
treeCalc(
  data     = sample_trees,
  eval     = "ung_1",
  dbh      = "DBH",
  species  = "SPECIES",
  output   = "biomass"
)

# Convert to carbon in Mg/ha
treeCalc(
  data        = sample_trees,
  eval        = "ung_1",
  dbh         = "DBH",
  species     = "SPECIES",
  appearance  = "APPEARANCE",
  output      = "carbon Mg/ha",
  decay       = TRUE,
  plot_radius = 11.28
)
```

## Functions

### Above-Ground Biomass

| Function | Description |
|----|----|
| `treeCalc()` | Total above-ground biomass (sum of all components) |
| `woodCalc()` | Woody stem biomass |
| `barkCalc()` | Bark biomass (optional partial-loss adjustment via `rem_bark`) |
| `branchCalc()` | Branch biomass |
| `foliageCalc()` | Foliage biomass |

All component functions accept the same core arguments and produce
results that sum exactly to `treeCalc()` output.

### Below-Ground Biomass

| Function | Description |
|----|----|
| `rootCalc()` | Root biomass using Li et al. (2003); takes AGB output from `treeCalc()` |

### Utilities

| Function | Description |
|----|----|
| `jenkinsRatio()` | Decompose total biomass into component proportions (Jenkins et al. 2003) |

## Key Arguments

| Argument | Description | Values |
|----|----|----|
| `eval` | Equation set | `"ung_1"`, `"ung_2"`, `"lambert_1"`, `"lambert_2"`, `"jenkins"` |
| `output` | Output type and unit | `"biomass"`, `"biomass Mg/ha"`, `"carbon"`, `"carbon Mg/ha"` |
| `decay` | Apply decay class reduction (Harmon et al. 2011) | `TRUE` / `FALSE` |
| `plot_radius` | Fixed-area plot radius for per-hectare outputs (m) | `3.99`, `5.64`, `7.98`, `11.28` |
| `appearance` | NFI tree appearance code (1–7) | Required when `decay = TRUE` |
| `crown_cond` | NFI crown condition code (1–5) | Required for branch and foliage |

Species are identified by **NFI species codes**. Supported species vary
by equation set — see `?treeCalc` or the vignettes for full species
lists.

## Vignettes

- **Getting Started** — basic workflow, output options, equation set
  comparison, decay adjustment
- **Component Biomass** — individual components, bark loss, Jenkins
  ratio decomposition

``` r
vignette("getting-started", package = "ForestBiomass")
vignette("component-biomass", package = "ForestBiomass")
```

## Status

This package is under active development. The API is subject to change.

| Component        | Function         | Status   |
|------------------|------------------|----------|
| Woody stem       | `woodCalc()`     | Complete |
| Bark             | `barkCalc()`     | Complete |
| Branches         | `branchCalc()`   | Complete |
| Foliage          | `foliageCalc()`  | Complete |
| Total AGB        | `treeCalc()`     | Complete |
| Root biomass     | `rootCalc()`     | Complete |
| Component ratios | `jenkinsRatio()` | Complete |

------------------------------------------------------------------------

**Author:** Thomson Harris — <thomsonharris@gmail.com> **License:** MIT
