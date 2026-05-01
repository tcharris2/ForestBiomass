# Internal Function: Biomass/Carbon output modifier

Internal Function: Biomass/Carbon output modifier

## Usage

``` r
carbonMod(output, plot_radius = 11.28)
```

## Arguments

- output:

  One of "biomass", "biomass Mg/ha", "carbon", or "carbon Mg/ha".

- plot_radius:

  Plot radius in metres. One of 3.99, 5.64, 7.98, or 11.28. Default
  11.28 m.

## Value

A numeric multiplier applied to raw allometric output (kg) to reach the
requested units.

## Examples

``` r
carbonMod("biomass")
#> Error in carbonMod("biomass"): could not find function "carbonMod"
```
