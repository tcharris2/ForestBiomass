# Sample tree measurements

Six simulated BC tree measurements for use in package examples and
vignettes. Covers five softwood and one hardwood species identified by
NFI species codes, with a range of sizes, decay states, and crown
conditions. All species are compatible with Ung et al. (2008) equations,
Jenkins et al. (2003) equations, and the Li et al. (2003) root biomass
equations.

## Usage

``` r
sample_trees
```

## Format

A data frame with 6 rows and 5 columns:

- SPECIES:

  NFI species code. See
  [`UNG_1`](https://tcharris2.github.io/ForestBiomass/reference/UNG_1.md)
  for Ung-compatible codes.

- DBH:

  Diameter at breast height (cm).

- HEIGHT:

  Total tree height (m).

- APPEARANCE:

  Tree appearance code (1-7). 1 = recently dead/fresh; higher codes
  indicate increasing decay.

- CROWN_COND:

  Crown condition code (1-5). 1 = full crown; 5 = no crown.

## Source

Simulated data; see `data_R/sample_trees.R` to regenerate.
