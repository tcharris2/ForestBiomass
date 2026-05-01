# Data: Jenkins et al. (2003) component ratio equation coefficients

Data: Jenkins et al. (2003) component ratio equation coefficients

## Usage

``` r
JENKINS_RATIO
```

## Format

A data frame with 8 rows and 4 columns:

- WOOD_TYPE:

  "hardwood" or "softwood"

- COMPONENT:

  "foliage", "coarse_roots", "stem_bark", or "stem_wood"

- BETA_0:

  Intercept coefficient

- BETA_1:

  Slope coefficient

## Source

Values from Jenkins et al. (2003) National-scale biomass estimators for
United States tree species. Forest Science, 49(1): 12-35.

## Details

Used in the equation `ratio = exp(BETA_0 + BETA_1 / DBH)`, where DBH is
in cm and ratio is the proportion of total above-ground biomass
allocated to each component.
