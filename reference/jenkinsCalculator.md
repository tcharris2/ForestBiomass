# Internal Function: Jenkins Calculator

Internal Function: Jenkins Calculator

## Usage

``` r
jenkinsCalculator(
  data,
  dbh,
  species,
  appearance = NULL,
  output,
  decay,
  plot_radius = 11.28
)
```

## Arguments

- data:

  User specified dataframe.

- dbh:

  Column within data where DBH is specified.

- species:

  Column within data where species is specified. NFI codes.

- appearance:

  Column within data where tree appearance is specified.

- output:

  One of "biomass", "biomass Mg/ha", "carbon", or "carbon Mg/ha".

- decay:

  Logical. Should the decay class reduction factor be applied?

- plot_radius:

  Plot radius in metres for per-hectare expansion. Default 11.28 m.

## Value

A vector

## Examples

``` r
NA
#> [1] NA
```
