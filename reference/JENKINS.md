# Data: Jenkins et al. (2003) total above-ground biomass equation coefficients

Data: Jenkins et al. (2003) total above-ground biomass equation
coefficients

## Usage

``` r
JENKINS
```

## Format

A data frame with 11 rows and 3 columns:

- SPECIES_GROUP:

  Jenkins species group name

- BETA_0:

  Intercept coefficient

- BETA_1:

  Slope coefficient

## Source

Values from Jenkins et al. (2003) National-scale biomass estimators for
United States tree species. Forest Science, 49(1): 12-35. "Mixed
softwood" is an in-house addition: arithmetic mean of beta coefficients
across Cedar/larch, Douglas-fir, True fir/hemlock, Pine, and Spruce.

## Details

Used in the equation `bm = exp(BETA_0 + BETA_1 * log(DBH))`, where DBH
is in cm and bm is total above-ground biomass in kg.
