# Internal Function: Bark Calculator helper function

Internal Function: Bark Calculator helper function

## Usage

``` r
barkCalculator(
  data,
  method,
  output,
  dbh,
  height = NULL,
  species,
  rem_bark = NULL,
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

  Dataframe within the package to retrieve beta values from.

- output:

  One of "biomass", "biomass Mg/ha", "carbon", or "carbon Mg/ha".

- dbh:

  Column within data where DBH is specified.

- height:

  Column within data where Height is specified.

- species:

  Column within data where species is specified.

- rem_bark:

  Column within data where remaining bark percentage (0-100) is
  specified.

- func:

  Calls function ungEqn.

- appearance:

  Column within data where tree appearance is specified.

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
