# Jenkins Component Ratio Calculation

Calculates the ratio of each biomass component to total above-ground
biomass using Jenkins et al. (2003) equations. Components are foliage,
coarse roots, stem bark, and stem wood. Species are classified as
softwood or hardwood using `SPECIES_CLASS`. Formula:
`ratio = exp(b0 + b1 / DBH)`.

## Usage

``` r
jenkinsRatio(data, dbh, species)
```

## Arguments

- data:

  User specified dataframe.

- dbh:

  Column within data where Diameter at Breast Height (DBH) is specified
  (cm).

- species:

  Column within data where species is specified. NFI codes for species.

## Value

A named list of four numeric vectors: `foliage`, `coarse_roots`,
`stem_bark`, and `stem_wood`.

## Examples

``` r
jenkinsRatio(data = trees_data, dbh = "DBH", species = "LGTREE_NFI")
#> Error: object 'trees_data' not found
```
