# Bark Calculation

Calculates bark biomass or carbon per tree given either DBH or DBH and
Height. Calculations are done base on the allometric equations provided
in Ung et al., 2008 or Lambert et al., 2005. A species specific decay
class reduction factor can be applied (Harmon et al., 2011) if desired.

## Usage

``` r
barkCalc(
  data,
  eval = "ung_2",
  dbh,
  height = NULL,
  species,
  appearance = NULL,
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

  Which allomentic equation should be used? Default is "ung_2". Options
  are: "ung_1", "ung_2", "lambert_1", "lambert_2".

- dbh:

  Column within data where Diameter at Breast Height (dbh) is specified.

- height:

  Optional. Required for lambert_2 or ung_2.

- species:

  Column within data where species is specified. NFI codes for species.

- appearance:

  Optional. Required when decay = TRUE.

- rem_bark:

  Optional. Column within data where remaining bark percentage (0-100)
  is specified.

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
barkCalc(data = trees_data, eval = "ung_2", species = "LGTREE_NFI",
dbh = "DBH", height = "HEIGHT", appearance = "APPEARANCE",
rem_bark = "REM_BARK", output = "biomass", decay = TRUE)
#> Error: object 'trees_data' not found
```
