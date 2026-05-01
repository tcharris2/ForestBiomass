# Internal Function: Wood Calculator helper function

Internal Function: Wood Calculator helper function

## Usage

``` r
woodCalculator(
  data,
  method,
  output,
  dbh,
  height = NULL,
  species,
  func,
  appearance = NULL,
  decay = TRUE,
  plot_radius = 11.28
)
```

## Arguments

- data:

  User specified dataframe.

- method:

  Dataframe within the package to retrive beta values from. Options are
  "LAMBERT_1", "LAMBERT_2", "UNG_1", "UNG_2".

- output:

  One of "biomass", "biomass Mg/ha", "carbon", or "carbon Mg/ha".

- dbh:

  Column within data where Diameter at Breast Height (dbh) is specified.

- height:

  Column within data where Height is specified.

- species:

  Column within data where species is specified. NFI codes for species.

- func:

  Calls function ungEqn.

- appearance:

  Column within data where tree appearance is specified.

- decay:

  Logical with default = TRUE. Should the decay class reduction factor
  be applied?

- plot_radius:

  Plot radius in metres for per-hectare expansion. Default 11.28 m.

## Value

A vector

## Examples

``` r
NA
#> [1] NA
```
