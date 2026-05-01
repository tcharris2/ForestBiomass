# Tree Biomass Calculation

Calculates total above-ground tree biomass or carbon. Two methodologies
are available: (1) summing wood, branch, foliage, and bark components
using allometric equations from Ung et al., 2008 or Lambert et al.,
2005; or (2) direct total above-ground biomass via Jenkins et al., 2003
national-scale equations. A species-specific decay class reduction
factor (Harmon et al., 2011) can be applied.

## Usage

``` r
treeCalc(
  data,
  eval = "ung_2",
  dbh,
  height = NULL,
  species,
  appearance = NULL,
  crown_cond = NULL,
  rem_bark = NULL,
  output = "biomass",
  decay = TRUE,
  plot_radius = 11.28
)
```

## Arguments

- data:

  User specified dataframe.

- eval:

  Which equation set to use. Default is "ung_2". Options are: "ung_1",
  "ung_2", "lambert_1", "lambert_2" (component-sum pathway), or
  "jenkins" (Jenkins et al., 2003 direct total biomass).

- dbh:

  Column within data where Diameter at Breast Height (dbh) is specified.

- height:

  Optional. Required for "lambert_2" or "ung_2".

- species:

  Column within data where species is specified. NFI codes for species.

- appearance:

  Optional. Required when decay = TRUE.

- crown_cond:

  Column within data where crown condition is specified. Required for
  "ung_1", "ung_2", "lambert_1", "lambert_2". Not used with "jenkins".

- rem_bark:

  Optional. Column within data where remaining bark percentage (0-100)
  is specified. Not used with "jenkins".

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
treeCalc(data = trees_data, eval = "ung_2", species = "LGTREE_NFI",
dbh = "DBH", height = "HEIGHT", appearance = "APPEARANCE",
crown_cond = "CROWN_COND", output = "biomass", decay = TRUE)
#> Error: object 'trees_data' not found

treeCalc(data = trees_data, eval = "jenkins", species = "LGTREE_NFI",
dbh = "DBH", appearance = "APPEARANCE", output = "biomass", decay = TRUE)
#> Error: object 'trees_data' not found
```
