# Root Biomass Calculation

Calculates below-ground (root) biomass or carbon using species-specific
root biomass equations from Li et al. (2003). Requires a pre-computed
above-ground biomass column. Specify the units of that column via
`units`; if `"kg"`, a `plot_radius` is required to convert to Mg/ha
before applying the equations. Root decay is not applied and must be
handled separately.

## Usage

``` r
rootCalc(
  data,
  biomass,
  species,
  units,
  root_type = "total",
  output = "biomass Mg/ha",
  plot_radius = NULL
)
```

## Arguments

- data:

  User specified dataframe.

- biomass:

  Column within data where pre-computed above-ground biomass is
  specified.

- species:

  Column within data where species is specified. NFI codes for species.

- units:

  Units of the biomass column. Must be specified: `"Mg/ha"` or `"kg"`.

- root_type:

  Which root fraction to return. One of "total" (default), "fine", or
  "coarse".

- output:

  One of "biomass Mg/ha" (default) or "carbon Mg/ha".

- plot_radius:

  Plot radius in metres. Required when `units = "kg"`. Must be one of
  3.99, 5.64, 7.98, or 11.28.

## Value

A numeric vector.

## Examples

``` r
trees_data$AGB <- treeCalc(trees_data, eval = "ung_2", species = "LGTREE_NFI",
  dbh = "DBH", height = "HEIGHT", appearance = "APPEARANCE",
  crown_cond = "CROWN_COND", output = "biomass Mg/ha", decay = TRUE)
#> Error: object 'trees_data' not found
rootCalc(trees_data, biomass = "AGB", species = "LGTREE_NFI", units = "Mg/ha")
#> Error: object 'trees_data' not found
```
