# rootCalc Design Spec

**Date:** 2026-04-28
**Status:** Approved

---

## Overview

`rootCalc()` calculates below-ground (root) biomass or carbon per tree by applying
species-specific root-to-shoot ratios from Li et al. (2003) to a pre-computed
above-ground biomass column. It does not use allometric equations (DBH/Height) and
does not follow the Ung/Lambert dispatch pattern of the other component functions.

**Source:** Li, Z., Kurz, W.A., Apps, M.J., and Beane, S.J. (2003). Belowground biomass
dynamics in the Carbon Budget Model of the Canadian Forest Sector: recent improvements
and implications for the estimation of NPP and NEP. *Canadian Journal of Forest Research*,
33(1): 126–136.

Root decay is intentionally excluded from this implementation and will be handled
separately in a future addition.

---

## Architecture

Two new R files and one new data object:

| File | Role |
|------|------|
| `R/rootCalc.R` | User-facing function — validates inputs, dispatches to `rootCalculator()` |
| `R/rootCalculator.R` | Internal — iterates rows, applies ratio × biomass × carbon modifier |
| `data_R/li2003data.R` | Script that creates the `LI_2003` data object |
| `data/LI_2003.rda` | Compiled data object loaded by the package |

---

## Data Object: `LI_2003`

A flat dataframe indexed by NFI species code. Each species maps to a softwood/hardwood
classification and the corresponding root-to-shoot ratios from Li et al. (2003).

| Column | Type | Description |
|--------|------|-------------|
| `SPECIES` | character | NFI species code (e.g. `"PSEU_MEN"`) |
| `WOOD_TYPE` | character | `"softwood"` or `"hardwood"` |
| `FINE_RATIO` | numeric | Fine root fraction of above-ground biomass |
| `COARSE_RATIO` | numeric | Coarse root fraction of above-ground biomass |

Species coverage mirrors the existing `UNG_1` / `UNG_2` species list. The softwood/hardwood
classification determines which Li et al. (2003) ratio applies.

---

## Function Signatures

```r
rootCalc <- function(data,
                     biomass,             # column name: pre-computed above-ground biomass
                     species,             # column name: NFI species codes
                     root_type = "total", # "fine", "coarse", or "total"
                     output = "biomass")  # "biomass" (kg) or "carbon" (Mg/ha)

rootCalculator <- function(data, biomass, species, root_type, output)
```

`rootCalc()` is the only exported function. `rootCalculator()` is internal.

---

## Data Flow

```
User dataframe
    │
    ├─ validate: all species present in LI_2003
    ├─ validate: biomass column is numeric
    ├─ validate: root_type in c("fine", "coarse", "total")
    ├─ validate: output in c("biomass", "carbon")
    │
    └─ rootCalculator() [per row i]:
            ratio      ← LI_2003 lookup by species:
                            "fine"   → FINE_RATIO
                            "coarse" → COARSE_RATIO
                            "total"  → FINE_RATIO + COARSE_RATIO
            carbon_mod ← carbonMod(output)
            result[i]  ← data[[biomass]][i] × ratio × carbon_mod
```

---

## Error Handling

| Condition | Response |
|-----------|----------|
| Species not in `LI_2003` | `rlang::abort()` |
| Biomass column not numeric | `stop()` |
| NAs in biomass column | `message()` warning |
| Invalid `root_type` | `rlang::abort()` |
| Invalid `output` | `rlang::abort()` |

**Console messages on success:**
```
Output: biomass (kg)      # or "carbon (Mg/ha)"
Root type: total          # whichever root_type was selected
```

---

## Integration with `treeCalc()`

`treeCalc()` currently has `include_root = FALSE` with a stub that raises an error.
Once `rootCalc()` is implemented, the stub is removed and `treeCalc()` calls
`rootCalc()` internally — passing the summed above-ground biomass vector as the
`biomass` input. No `decay` or `appearance` arguments are passed at this stage.

---

## Testing Plan

File: `tests/testthat/test-rootCalc.R`

**Input validation:**
- Aborts for species not in `LI_2003`
- Aborts for non-numeric biomass column
- Warns on NAs in biomass column
- Aborts on invalid `root_type`
- Aborts on invalid `output`

**Output correctness:**
- Returns a numeric vector with one value per row
- Returns non-negative values
- `"total"` equals `"fine"` + `"coarse"` for the same input
- Carbon output is less than biomass output
- Known-value test: single row, known species, known biomass → verify `biomass × ratio` exactly

**`root_type` behaviour:**
- `"fine"` returns smaller values than `"total"`
- `"coarse"` returns smaller values than `"total"`

---

## Future Work

- Root decay: species-specific decay reduction for below-ground biomass (to be designed separately)
- Additional methods: the `root_type` argument structure anticipates a future `method` parameter (e.g. Cairns et al. 1997) without requiring a redesign
