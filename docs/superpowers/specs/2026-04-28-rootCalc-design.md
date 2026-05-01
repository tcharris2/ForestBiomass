# rootCalc Design Spec

**Date:** 2026-04-28
**Status:** Approved

---

## Overview

`rootCalc()` calculates below-ground (root) biomass or carbon per tree by applying
species-specific root biomass equations from Li et al. (2003) to a pre-computed
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

Two new R files and two new data objects:

| File | Role |
|------|------|
| `R/rootCalc.R` | User-facing function — validates inputs, dispatches to `rootCalculator()` |
| `R/rootCalculator.R` | Internal — iterates rows, applies root biomass equations and carbon modifier |
| `data_R/speciesclassdata.R` | Script that creates the `SPECIES_CLASS` data object |
| `data_R/li2003data.R` | Script that creates the `LI_2003` data object |
| `data/SPECIES_CLASS.rda` | Compiled species classification data object |
| `data/LI_2003.rda` | Compiled Li et al. (2003) root biomass coefficients |

---

## Data Objects

### `SPECIES_CLASS`

A flat dataframe mapping NFI species codes to a softwood/hardwood classification.
Method-agnostic — shared across all root biomass methods. Species coverage is drawn
from the union of species present in the Ung and Lambert datasets, excluding
ambiguous catch-all codes.

| Column | Type | Description |
|--------|------|-------------|
| `SPECIES` | character | NFI species code |
| `WOOD_TYPE` | character | `"softwood"` or `"hardwood"` |

**Softwoods (20):**
`PICE_MAR`, `PSEU_MEN`, `PICE_ENG`, `PINU_CON`, `ABIE_AMA`, `PICE_SIT`, `ABIE_LAS`,
`TSUG_HET`, `THUJ_PLI`, `PICE_GLA`, `ABIE_BAL`, `TSUG_CAN`, `THUJ_OCC`, `PINU_STR`,
`PINU_BAN`, `PINU_RES`, `PICE_RUB`, `JUNI_VIR`, `GENC_SPP`, `LARI_LAR`

**Hardwoods (23):**
`ALNU_RUB`, `POPU_TRI`, `POPU_TRE`, `BETU_PAP`, `POPU_BAL`, `TILI_AME`, `FAGU_GRA`,
`FRAX_NIG`, `PRUN_SER`, `BETU_POP`, `CARY_SPP`, `OSTR_VIR`, `POPU_GRA`, `FRAX_PEN`,
`ACER_RUB`, `QUER_RUB`, `ACER_SAC`, `ACER_SAH`, `FRAX_AME`, `ULMU_AME`, `QUER_ALB`,
`BETU_ALL`, `GENH_SPP`

**Excluded:** `GENA_SPP`, `ALL_SPP`, `HARD_SPP`, `SOFT_SPP` — ambiguous or redundant
catch-all codes.

---

### `LI_2003`

A two-row dataframe storing the root biomass equation coefficients from Li et al. (2003),
one row per wood type. Both softwood and hardwood equations share the form
`RB = β₁ × AB^β₂`, where RB is root biomass and AB is above-ground biomass.

| Column | Type | Description |
|--------|------|-------------|
| `WOOD_TYPE` | character | `"softwood"` or `"hardwood"` |
| `BETA_1` | numeric | Multiplier coefficient |
| `BETA_2` | numeric | Exponent coefficient |

| WOOD_TYPE | BETA_1 | BETA_2 |
|-----------|--------|--------|
| softwood  | 0.222  | 1.000  |
| hardwood  | 1.576  | 0.615  |

The softwood exponent of 1.0 makes the equation linear (RB = 0.222 × AB).

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

## Calculation

The calculation proceeds in two steps per row:

**Step 1 — Total root biomass:**

Look up `WOOD_TYPE` from `SPECIES_CLASS` by species code, then look up `BETA_1` and
`BETA_2` from `LI_2003` by `WOOD_TYPE`:

```
RB = BETA_1 × AB^BETA_2
```

**Step 2 — Fine root proportion (only when `root_type` is `"fine"` or `"coarse"`):**

```
Pf = 0.072 + 0.354 × exp(-0.060 × RB)
```

The Pf coefficients are fixed constants from Li et al. (2003), independent of species
or wood type. They are defined inline in `rootCalculator()`.

**Step 3 — Select output by `root_type`:**

| `root_type` | Return value |
|-------------|-------------|
| `"total"` | `RB` |
| `"fine"` | `Pf × RB` |
| `"coarse"` | `(1 - Pf) × RB` |

**Step 4 — Apply carbon modifier:**

```
result = selected_value × carbonMod(output)
```

---

## Data Flow

```
User dataframe
    │
    ├─ validate: all species present in SPECIES_CLASS
    ├─ validate: biomass column is numeric
    ├─ validate: root_type in c("fine", "coarse", "total")
    ├─ validate: output in c("biomass", "carbon")
    │
    └─ rootCalculator() [per row i]:
            WOOD_TYPE  ← SPECIES_CLASS lookup by species code
            BETA_1/2   ← LI_2003 lookup by WOOD_TYPE
            RB         ← BETA_1 × AB^BETA_2
            Pf         ← 0.072 + 0.354 × exp(-0.060 × RB)  [if root_type != "total"]
            value      ← RB | Pf×RB | (1-Pf)×RB
            result[i]  ← value × carbonMod(output)
```

---

## Error Handling

Note: `rootCalc()` does not use the existing `validateSpecies()` helper (which is
coupled to the Ung/Lambert data). It performs its own inline check against
`SPECIES_CLASS$SPECIES`.

| Condition | Response |
|-----------|----------|
| Species not in `SPECIES_CLASS` | `rlang::abort()` |
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
- Aborts for species not in `SPECIES_CLASS`
- Aborts for non-numeric biomass column
- Warns on NAs in biomass column
- Aborts on invalid `root_type`
- Aborts on invalid `output`

**Output correctness:**
- Returns a numeric vector with one value per row
- Returns non-negative values
- `"total"` equals `"fine"` + `"coarse"` for the same input
- Carbon output is less than biomass output
- Known-value test (softwood): single row, known AB → verify `0.222 × AB` exactly
- Known-value test (hardwood): single row, known AB → verify `1.576 × AB^0.615` exactly

**`root_type` behaviour:**
- `"fine"` returns smaller values than `"total"`
- `"coarse"` returns smaller values than `"total"`
- Softwood and hardwood rows return different values for the same AB input

---

## Future Work

- Root decay: species-specific decay reduction for below-ground biomass (to be designed separately)
- Additional methods: a `method` parameter (e.g. Cairns et al. 1997) can be added without
  redesigning the current structure — `SPECIES_CLASS` is already method-agnostic
