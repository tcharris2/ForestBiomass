# Jenkins et al. 2003 — treeCalc() Integration Design Spec

**Date:** 2026-04-28
**Status:** Approved

---

## Overview

Adds Jenkins et al. (2003) as a new `eval = "jenkins"` option in `treeCalc()`, giving
users a second methodology for calculating total above-ground tree biomass. Unlike the
existing Ung/Lambert pathway (which sums four components), Jenkins returns total
above-ground biomass directly via a single allometric equation requiring only DBH.

This implementation also renames all existing `eval` strings across the package to
remove the redundant `"_eqn"` substring — a breaking API change.

**Source:** Jenkins, J.C., Chojnacky, D.C., Heath, L.S., and Birdsey, R.A. (2003).
National-scale biomass estimators for United States tree species. *Forest Science*,
49(1): 12–35.

---

## Architecture

### New Files

| File | Role |
|------|------|
| `R/jenkinsCalculator.R` | Internal — row loop, species group lookup, Jenkins equation, decay, carbon modifier |
| `data_R/jenkinsdata.R` | Script creating the `JENKINS` coefficient data object |
| `data_R/jenkinsgroupsdata.R` | Script creating the `JENKINS_GROUPS` mapping data object |
| `data/JENKINS.rda` | Compiled Jenkins species group coefficients |
| `data/JENKINS_GROUPS.rda` | Compiled NFI code → Jenkins species group mapping |

### Modified Files

| File | Change |
|------|--------|
| `R/treeCalc.R` | Add `"jenkins"` eval option; warn on unused `crown_cond`/`rem_bark`; dispatch to `jenkinsCalculator()` |
| `R/woodCalc.R` | Rename eval strings |
| `R/branchCalc.R` | Rename eval strings |
| `R/foliageCalc.R` | Rename eval strings |
| `R/barkCalc.R` | Rename eval strings |
| `R/resolveMethod.R` | Update dispatch table keys |
| `tests/testthat/test-woodCalc.R` | Update eval string references |
| `tests/testthat/test-branchCalc.R` | Update eval string references |
| `tests/testthat/test-foliageCalc.R` | Update eval string references |
| `tests/testthat/test-barkCalc.R` | Update eval string references |

---

## Eval String Rename (Breaking Change)

All `*Calc()` functions and tests change from:

| Old string | New string |
|------------|------------|
| `"ung_eqn_1"` | `"ung_1"` |
| `"ung_eqn_2"` | `"ung_2"` |
| `"lambert_eqn_1"` | `"lambert_1"` |
| `"lambert_eqn_2"` | `"lambert_2"` |

This affects the valid `eval` argument in `woodCalc()`, `branchCalc()`, `foliageCalc()`,
`barkCalc()`, and `treeCalc()`, and the dispatch table in `resolveMethod()`.

---

## Data Objects

### `JENKINS`

Coefficient table for the Jenkins total above-ground biomass equation:

**`bm = exp(β₀ + β₁ × ln(DBH))`**

where `bm` is biomass in kg and `DBH` is diameter at breast height in cm.

| Column | Type | Description |
|--------|------|-------------|
| `SPECIES_GROUP` | character | Jenkins species group name |
| `BETA_0` | numeric | Intercept coefficient |
| `BETA_1` | numeric | Slope coefficient |

Eleven rows — the ten original Jenkins et al. (2003) species groups plus one
in-house addition:

| SPECIES_GROUP | BETA_0 | BETA_1 |
|---------------|--------|--------|
| Cedar/larch | -2.0336 | 2.2592 |
| Douglas-fir | -2.2304 | 2.4435 |
| True fir/hemlock | -2.5384 | 2.4814 |
| Pine | -2.5356 | 2.4249 |
| Spruce | -2.0773 | 2.3323 |
| Aspen/alder/cottonwood/willow | -2.2094 | 2.3867 |
| Soft maple/birch | -1.9123 | 2.3651 |
| Mixed hardwood | -2.4800 | 2.4835 |
| Hard maple/oak/hickory/beech | -2.0127 | 2.4342 |
| Juniper/oak/mesquite | -0.7152 | 1.7029 |
| Mixed softwood | -2.2831 | 2.3883 |

"Mixed softwood" coefficients are the arithmetic mean of β₀ and β₁ across
Cedar/larch, Douglas-fir, True fir/hemlock, Pine, and Spruce.

---

### `JENKINS_GROUPS`

Maps NFI species codes to Jenkins species groups. Coverage is the union of species
present in the Ung and Lambert datasets (excluding ambiguous catch-all codes handled
separately below).

| Column | Type | Description |
|--------|------|-------------|
| `SPECIES` | character | NFI species code |
| `SPECIES_GROUP` | character | Corresponding Jenkins species group |

**Mappings:**

| NFI Code | Common Name | Jenkins Group |
|----------|-------------|---------------|
| `PICE_MAR` | Black spruce | Spruce |
| `PSEU_MEN` | Douglas-fir | Douglas-fir |
| `PICE_ENG` | Engelmann spruce | Spruce |
| `PINU_CON` | Lodgepole pine | Pine |
| `ABIE_AMA` | Amabilis fir | True fir/hemlock |
| `ALNU_RUB` | Red alder | Aspen/alder/cottonwood/willow |
| `POPU_TRI` | Black cottonwood | Aspen/alder/cottonwood/willow |
| `PICE_SIT` | Sitka spruce | Spruce |
| `ABIE_LAS` | Subalpine fir | True fir/hemlock |
| `POPU_TRE` | Trembling aspen | Aspen/alder/cottonwood/willow |
| `TSUG_HET` | Western hemlock | True fir/hemlock |
| `THUJ_PLI` | Western red cedar | Cedar/larch |
| `BETU_PAP` | White/paper birch | Soft maple/birch |
| `PICE_GLA` | White spruce | Spruce |
| `ABIE_BAL` | Balsam fir | True fir/hemlock |
| `POPU_BAL` | Balsam poplar | Aspen/alder/cottonwood/willow |
| `TILI_AME` | Basswood | Mixed hardwood |
| `FAGU_GRA` | Beech | Hard maple/oak/hickory/beech |
| `FRAX_NIG` | Black ash | Mixed hardwood |
| `PRUN_SER` | Black cherry | Mixed hardwood |
| `TSUG_CAN` | Eastern hemlock | True fir/hemlock |
| `JUNI_VIR` | Eastern redcedar | Cedar/larch |
| `THUJ_OCC` | Eastern white-cedar | Cedar/larch |
| `PINU_STR` | Eastern white pine | Pine |
| `BETU_POP` | Grey birch | Soft maple/birch |
| `CARY_SPP` | Hickory | Hard maple/oak/hickory/beech |
| `OSTR_VIR` | Hop-hornbeam | Mixed hardwood |
| `PINU_BAN` | Jack pine | Pine |
| `POPU_GRA` | Largetooth aspen | Aspen/alder/cottonwood/willow |
| `FRAX_PEN` | Red ash | Mixed hardwood |
| `ACER_RUB` | Red maple | Soft maple/birch |
| `QUER_RUB` | Red oak | Hard maple/oak/hickory/beech |
| `PINU_RES` | Red pine | Pine |
| `PICE_RUB` | Red spruce | Spruce |
| `ACER_SAC` | Silver maple | Soft maple/birch |
| `ACER_SAH` | Sugar maple | Hard maple/oak/hickory/beech |
| `LARI_LAR` | Tamarack larch | Cedar/larch |
| `FRAX_AME` | White ash | Mixed hardwood |
| `ULMU_AME` | White elm | Mixed hardwood |
| `QUER_ALB` | White oak | Hard maple/oak/hickory/beech |
| `BETU_ALL` | Yellow birch | Soft maple/birch |
| `GENH_SPP` | All hardwoods (Ung) | Mixed hardwood |
| `GENC_SPP` | All softwoods (Ung) | Mixed softwood |

---

## Function Signatures

`treeCalc()` gains `"jenkins"` as a valid `eval` option. The `height`, `crown_cond`,
and `rem_bark` arguments become unused when `eval = "jenkins"`.

```r
treeCalc <- function(data, eval = "ung_2",
                     dbh, height = NULL, species, appearance = NULL,
                     crown_cond = NULL, rem_bark = NULL,
                     output = "biomass", decay = TRUE)
```

Note: `crown_cond` becomes `NULL`-defaulted (previously required) to accommodate
the Jenkins pathway cleanly. `include_root` is removed — root biomass will be
handled by a dedicated `rootCalc()` function.

```r
jenkinsCalculator <- function(data, dbh, species, appearance = NULL,
                               output, decay)
```

---

## Data Flow

```
treeCalc(eval = "jenkins")
    │
    ├─ warn if crown_cond supplied ("crown_cond not used with eval = 'jenkins'")
    ├─ warn if rem_bark supplied ("rem_bark not used with eval = 'jenkins'")
    ├─ validate species against JENKINS_GROUPS$SPECIES
    ├─ validate dbh is numeric
    ├─ warn on NAs in dbh
    ├─ validate output in c("biomass", "carbon")
    ├─ validate decay = TRUE requires appearance
    │
    └─ jenkinsCalculator() [per row i]:
            group      ← JENKINS_GROUPS lookup by species code
            β₀, β₁    ← JENKINS lookup by species group
            bm         ← exp(β₀ + β₁ × ln(data[[dbh]][i]))
            decay_mod  ← DCRF(data, appearance, species, i)  [or 1 if decay = FALSE]
            carbon_mod ← carbonMod(output)
            result[i]  ← bm × decay_mod × carbon_mod
```

---

## Error Handling

When `eval = "jenkins"`, species validation is performed inline against
`JENKINS_GROUPS$SPECIES` rather than via the existing `validateSpecies()` helper,
which is coupled to the Ung/Lambert data objects. The existing Ung/Lambert pathway
in `treeCalc()` continues to use `validateSpecies()` unchanged.

| Condition | Response |
|-----------|----------|
| `crown_cond` supplied with `eval = "jenkins"` | `message()` warning |
| `rem_bark` supplied with `eval = "jenkins"` | `message()` warning |
| Species not in `JENKINS_GROUPS` | `rlang::abort()` |
| DBH column not numeric | `stop()` |
| NAs in DBH column | `message()` warning |
| Invalid `output` | `rlang::abort()` |
| `decay = TRUE` with no `appearance` | `stop()` |

---

## Testing Plan

**New file:** `tests/testthat/test-treeCalc-jenkins.R`

*Input validation:*
- Aborts for species not in `JENKINS_GROUPS`
- Aborts for non-numeric DBH
- Warns on NAs in DBH
- Warns when `crown_cond` supplied with `eval = "jenkins"`
- Warns when `rem_bark` supplied with `eval = "jenkins"`
- Aborts on invalid `output`
- Aborts when `decay = TRUE` and `appearance` not supplied

*Output correctness:*
- Returns numeric vector with one value per row
- Returns positive values
- Carbon output less than biomass output
- Known-value test: single row, known species group, known DBH → verify `exp(β₀ + β₁ × ln(DBH))` exactly
- Jenkins and Ung produce different values for same inputs
- Decay reduces values for trees with appearance code ≥ 3

*Eval string rename:*
- All existing `*Calc()` tests updated from old to new eval strings and verified passing

---

## Future Work

- `rootCalc()` using Jenkins root component ratios (`root_ratio = exp(β₀ + β₁ / DBH)`)
  will consume Jenkins total biomass output — see memory entry for design details
- Jenkins component ratios (foliage, bark, branch) could be added to individual
  component functions in a future iteration
