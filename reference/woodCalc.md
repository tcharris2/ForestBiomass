# Wood Calculation

Calculates wood biomass or carbon per tree given either DBH or DBH and
Height. Calculations are done base on the allometric equations provided
in Ung et al., 2008 or Lambert et al., 2005. A species specific decay
class reduction factor can be applied (Harmon et al., 2011) if desired.

## Usage

``` r
woodCalc(
  data,
  eval = "ung_2",
  dbh,
  height = NULL,
  species,
  appearance = NULL,
  output = "biomass",
  decay = TRUE,
  plot_radius = 11.28
)
```

## Arguments

- data:

  User specified dataframe.

- eval:

  Which allomentic equation should be used? Default is set to Ung
  Equation 2 where biomass is calculated with both DBH and Height.
  Options are: "ung_1" for DBH based calculations, "ung_2" for DBH and
  Height based calculations, "lambert_1" for DBH based calculations, and
  "lambert_2" for DBH and Height based calculations. Use Ung equations
  for within British Columbia and use Lambert equations for species
  found in Eastern Canada.

- dbh:

  Column within data where Diameter at Breast Height (dbh) is specified.

- height:

  Optional. Required if using lambert_2 or ung_2. Column within data
  where Height is specified.

- species:

  Column within data where species is specified. NFI codes for species.

- appearance:

  Optional. Required when decay = TRUE. Column within data where tree
  appearance is specified.

- output:

  One of "biomass" (kg, default), "biomass Mg/ha", "carbon" (kg), or
  "carbon Mg/ha".

- decay:

  Logical with default = TRUE. Should the decay class reduction factor
  be applied?

- plot_radius:

  Plot radius in metres. Required when output is "biomass Mg/ha" or
  "carbon Mg/ha". Must be one of 3.99, 5.64, 7.98, or 11.28. Default
  11.28 m.

## Value

A vector.

## Examples

``` r
woodCalc(data = trees_data,
eval = "ung_2",
species = "LGTREE_NFI",
dbh = "DBH",
height = "HEIGHT",
appearance = "APPEARANCE",
output = "biomass",
decay = TRUE)
#> Error: object 'trees_data' not found
```
