# Vignettes Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Create two user-facing vignettes for the ForestBiomass package — one covering the full above-ground + root biomass workflow, one covering per-component estimation and Jenkins ratios.

**Architecture:** Each vignette is a standalone R Markdown file in `vignettes/`. A shared `sample_trees` dataset is added to the package so all examples are self-contained and reproducible. `DESCRIPTION` is updated to declare `knitr` as the vignette builder.

**Tech Stack:** R, roxygen2, knitr, rmarkdown, devtools. **Always use PowerShell** for shell commands — the project path contains spaces (`OneDrive - UBC`).

---

## File Structure

| File | Action | Responsibility |
|---|---|---|
| `data_R/sample_trees.R` | Create | Script to build and save `sample_trees.rda` |
| `R/sample_trees.R` | Create | roxygen2 documentation for `sample_trees` |
| `data/sample_trees.rda` | Generated | Run `data_R/sample_trees.R` via Rscript |
| `man/sample_trees.Rd` | Generated | Run `devtools::document()` |
| `DESCRIPTION` | Modify | Add knitr/rmarkdown to Suggests; add VignetteBuilder |
| `vignettes/getting-started.Rmd` | Create | treeCalc() workflow: equation sets, units, decay, rootCalc() |
| `vignettes/component-biomass.Rmd` | Create | Per-component functions, rem_bark, jenkinsRatio() |

---

### Task 1: Create sample_trees dataset

**Files:**
- Create: `data_R/sample_trees.R`
- Create: `R/sample_trees.R`
- Generated: `data/sample_trees.rda`
- Generated: `man/sample_trees.Rd`

- [ ] **Step 1: Write the data creation script**

Create `data_R/sample_trees.R`:

```r
sample_trees <- data.frame(
  SPECIES    = c("PSEU_MEN", "PINU_CON", "TSUG_HET", "POPU_TRE", "PICE_MAR", "PICE_GLA"),
  DBH        = c(32.4, 18.7, 14.2, 27.6,  9.8, 41.3),
  HEIGHT     = c(22.1, 14.5, 11.8, 20.3,  8.4, 28.7),
  APPEARANCE = c(   1,    1,    3,    2,    5,    1),
  CROWN_COND = c(   1,    2,    3,    1,    4,    1),
  stringsAsFactors = FALSE
)

usethis::use_data(sample_trees, overwrite = TRUE)
```

Species selected:
- PSEU_MEN = Douglas-fir (softwood)
- PINU_CON = Lodgepole pine (softwood)
- TSUG_HET = Western hemlock (softwood)
- POPU_TRE = Trembling aspen (hardwood)
- PICE_MAR = Black spruce (softwood)
- PICE_GLA = White spruce (softwood)

All six species are present in UNG_1, UNG_2, JENKINS_GROUPS, and SPECIES_CLASS, so they work across every equation set and with rootCalc()/jenkinsRatio().

- [ ] **Step 2: Write the roxygen2 documentation**

Create `R/sample_trees.R`:

```r
#' Sample tree measurements
#'
#' Six simulated BC tree measurements for use in package examples and vignettes.
#' Covers five softwood and one hardwood species identified by NFI species codes,
#' with a range of sizes, decay states, and crown conditions. All species are
#' compatible with Ung et al. (2008) equations, Jenkins et al. (2003) equations,
#' and the Li et al. (2003) root biomass equations.
#'
#' @format A data frame with 6 rows and 5 columns:
#' \describe{
#'   \item{SPECIES}{NFI species code. See \code{\link{UNG_1}} for Ung-compatible codes.}
#'   \item{DBH}{Diameter at breast height (cm).}
#'   \item{HEIGHT}{Total tree height (m).}
#'   \item{APPEARANCE}{Tree appearance code (1-7). 1 = recently dead/fresh;
#'     higher codes indicate increasing decay.}
#'   \item{CROWN_COND}{Crown condition code (1-5). 1 = full crown; 5 = no crown.}
#' }
#' @source Simulated data.
"sample_trees"
```

- [ ] **Step 3: Generate the .rda file**

Run in PowerShell from the package root:

```powershell
Rscript "data_R/sample_trees.R"
```

Expected: no error output; `data/sample_trees.rda` appears.

- [ ] **Step 4: Generate the man page**

```powershell
Rscript -e "devtools::document()"
```

Expected: `man/sample_trees.Rd` is created; no warnings about `sample_trees`.

- [ ] **Step 5: Verify the dataset loads correctly**

```powershell
Rscript -e "devtools::load_all(); str(sample_trees)"
```

Expected output:
```
'data.frame':   6 obs. of  5 variables:
 $ SPECIES   : chr  "PSEU_MEN" "PINU_CON" "TSUG_HET" "POPU_TRE" ...
 $ DBH       : num  32.4 18.7 14.2 27.6 9.8 41.3
 $ HEIGHT    : num  22.1 14.5 11.8 20.3 8.4 28.7
 $ APPEARANCE: num  1 1 3 2 5 1
 $ CROWN_COND: num  1 2 3 1 4 1
```

- [ ] **Step 6: Commit**

```powershell
git add "data_R/sample_trees.R" "R/sample_trees.R" "data/sample_trees.rda" "man/sample_trees.Rd" NAMESPACE
git commit -m "feat: add sample_trees dataset for vignette examples"
```

---

### Task 2: Configure DESCRIPTION and vignette directory

**Files:**
- Modify: `DESCRIPTION`
- Create: `vignettes/` directory

- [ ] **Step 1: Update DESCRIPTION**

In `DESCRIPTION`, update the `Suggests:` block and add `VignetteBuilder` immediately after it.

Before:
```
Suggests:
    testthat (>= 3.0.0)
```

After:
```
Suggests:
    knitr,
    rmarkdown,
    testthat (>= 3.0.0)
VignetteBuilder: knitr
```

- [ ] **Step 2: Create the vignettes directory**

```powershell
New-Item -ItemType Directory -Path "vignettes" -Force
```

Expected: `vignettes/` directory exists.

- [ ] **Step 3: Verify the package still loads cleanly**

```powershell
Rscript -e "devtools::load_all()"
```

Expected: no errors.

- [ ] **Step 4: Commit**

```powershell
git add DESCRIPTION
git commit -m "chore: configure vignette infrastructure (knitr builder)"
```

---

### Task 3: Getting Started vignette

**Files:**
- Create: `vignettes/getting-started.Rmd`

This vignette covers the most common user journey: estimate total above-ground
biomass with `treeCalc()`, understand output options, then chain into `rootCalc()`.

- [ ] **Step 1: Write the vignette**

Create `vignettes/getting-started.Rmd`:

````rmd
---
title: "Getting Started with ForestBiomass"
output: rmarkdown::html_vignette
vignette: >
  %\VignetteIndexEntry{Getting Started with ForestBiomass}
  %\VignetteEngine{knitr::rmarkdown}
  %\VignetteEncoding{UTF-8}
---

```{r, include = FALSE}
knitr::opts_chunk$set(collapse = TRUE, comment = "#>")
```

```{r setup}
library(ForestBiomass)
```

ForestBiomass calculates above-ground and below-ground tree biomass using
published allometric equations. This vignette walks through the most common
workflow: estimating total above-ground biomass with `treeCalc()`, choosing
output units, applying decay corrections, and chaining into `rootCalc()` for
root biomass.

## Your data

`treeCalc()` requires a data frame with one row per tree. The package includes
`sample_trees`, a six-tree dataset covering common BC species:

```{r}
sample_trees
```

The required columns are:

| Column | Content | Notes |
|--------|---------|-------|
| Species | NFI code (e.g., `"PSEU_MEN"`) | See `?UNG_1` for valid Ung codes |
| DBH | Diameter at breast height (cm) | Required for all equation sets |
| Height | Total tree height (m) | Required for `ung_2` and `lambert_2` |
| Appearance | Appearance code (1-7) | Required when `decay = TRUE` |
| Crown condition | Crown condition code (1-5) | Required for Ung and Lambert pathways |

## Estimating total above-ground biomass

`treeCalc()` with `eval = "ung_2"` (the default) uses Ung et al. (2008) equations
for BC species, fitting biomass as a function of both DBH and height.

```{r}
agb <- treeCalc(
  data       = sample_trees,
  eval       = "ung_2",
  species    = "SPECIES",
  dbh        = "DBH",
  height     = "HEIGHT",
  appearance = "APPEARANCE",
  crown_cond = "CROWN_COND",
  output     = "biomass",
  decay      = TRUE
)
agb
```

Each value is the total above-ground biomass for one tree in kilograms.

## Output options

The `output` argument controls units and whether the result is carbon:

```{r}
# Per-tree biomass (kg) — default
suppressMessages(
  treeCalc(sample_trees, eval = "ung_2", species = "SPECIES",
           dbh = "DBH", height = "HEIGHT", appearance = "APPEARANCE",
           crown_cond = "CROWN_COND", output = "biomass", decay = FALSE)
)

# Per-tree carbon (kg) — biomass × 0.5
suppressMessages(
  treeCalc(sample_trees, eval = "ung_2", species = "SPECIES",
           dbh = "DBH", height = "HEIGHT", appearance = "APPEARANCE",
           crown_cond = "CROWN_COND", output = "carbon", decay = FALSE)
)

# Stand-level biomass (Mg/ha) — requires plot_radius
suppressMessages(
  treeCalc(sample_trees, eval = "ung_2", species = "SPECIES",
           dbh = "DBH", height = "HEIGHT", appearance = "APPEARANCE",
           crown_cond = "CROWN_COND", output = "biomass Mg/ha",
           decay = FALSE, plot_radius = 11.28)
)
```

The `plot_radius` argument controls the per-hectare expansion factor:

| Plot radius (m) | Trees per hectare |
|-----------------|-------------------|
| 3.99 | 200 |
| 5.64 | 100 |
| 7.98 | 50 |
| 11.28 | 25 |

## Choosing an equation set

Five `eval` options are available:

| `eval` | Source | Inputs needed | Best for |
|--------|--------|---------------|----------|
| `"ung_1"` | Ung et al. 2008 | DBH | BC — DBH only |
| `"ung_2"` | Ung et al. 2008 | DBH + height | BC — DBH and height (default) |
| `"lambert_1"` | Lambert et al. 2005 | DBH | Eastern Canada — DBH only |
| `"lambert_2"` | Lambert et al. 2005 | DBH + height | Eastern Canada — DBH and height |
| `"jenkins"` | Jenkins et al. 2003 | DBH | Any region — DBH only |

`"ung_1"` and `"ung_2"` use the same 17 BC species. Use `"lambert_1"` or
`"lambert_2"` for Eastern Canada species (see `?LAMBERT_1`). The `"jenkins"`
pathway covers all species in `JENKINS_GROUPS` and requires no height or crown
condition measurement.

## Decay class reduction

When `decay = TRUE` (the default), a species-specific decay class reduction
factor is applied from Harmon et al. (2011). Trees with appearance code 1
(freshly dead / recently fallen) receive no reduction; higher codes apply
increasing reductions. Live trees should use `decay = FALSE`.

```{r}
no_decay   <- suppressMessages(
  treeCalc(sample_trees, eval = "ung_2", species = "SPECIES",
           dbh = "DBH", height = "HEIGHT", appearance = "APPEARANCE",
           crown_cond = "CROWN_COND", output = "biomass", decay = FALSE)
)
with_decay <- suppressMessages(
  treeCalc(sample_trees, eval = "ung_2", species = "SPECIES",
           dbh = "DBH", height = "HEIGHT", appearance = "APPEARANCE",
           crown_cond = "CROWN_COND", output = "biomass", decay = TRUE)
)

data.frame(
  species    = sample_trees$SPECIES,
  appearance = sample_trees$APPEARANCE,
  no_decay   = round(no_decay,   1),
  with_decay = round(with_decay, 1),
  pct_reduction = round((1 - with_decay / no_decay) * 100, 1)
)
```

## Using the Jenkins pathway

When height or crown condition are unavailable, `eval = "jenkins"` estimates
total above-ground biomass directly from DBH alone:

```{r}
treeCalc(
  data       = sample_trees,
  eval       = "jenkins",
  species    = "SPECIES",
  dbh        = "DBH",
  appearance = "APPEARANCE",
  output     = "biomass",
  decay      = TRUE
)
```

## Estimating root biomass

`rootCalc()` applies Li et al. (2003) root equations to a pre-computed
above-ground biomass column. It requires the above-ground biomass to be in
Mg/ha (or kg with a `plot_radius` for conversion).

```{r}
sample_trees$AGB <- suppressMessages(
  treeCalc(sample_trees, eval = "ung_2", species = "SPECIES",
           dbh = "DBH", height = "HEIGHT", appearance = "APPEARANCE",
           crown_cond = "CROWN_COND", output = "biomass Mg/ha",
           decay = TRUE, plot_radius = 11.28)
)

rootCalc(
  data      = sample_trees,
  biomass   = "AGB",
  species   = "SPECIES",
  units     = "Mg/ha",
  root_type = "total",
  output    = "biomass Mg/ha"
)
```

Fine and coarse root fractions can be returned separately:

```{r}
fine   <- suppressMessages(
  rootCalc(sample_trees, biomass = "AGB", species = "SPECIES",
           units = "Mg/ha", root_type = "fine")
)
coarse <- suppressMessages(
  rootCalc(sample_trees, biomass = "AGB", species = "SPECIES",
           units = "Mg/ha", root_type = "coarse")
)
total  <- suppressMessages(
  rootCalc(sample_trees, biomass = "AGB", species = "SPECIES",
           units = "Mg/ha", root_type = "total")
)

data.frame(
  species = sample_trees$SPECIES,
  fine    = round(fine,   3),
  coarse  = round(coarse, 3),
  total   = round(total,  3)
)
```
````

- [ ] **Step 2: Render the vignette to verify it builds**

```powershell
Rscript -e "rmarkdown::render('vignettes/getting-started.Rmd')"
```

Expected: no errors or warnings; `vignettes/getting-started.html` is created.

- [ ] **Step 3: Open and inspect the HTML**

Open `vignettes/getting-started.html` in a browser. Check:
- All code chunks produce visible output
- The decay comparison table shows a non-zero `pct_reduction` for trees with appearance > 1
- The root fine + coarse columns sum to the total column

- [ ] **Step 4: Delete the generated HTML (not committed for packages)**

```powershell
Remove-Item "vignettes/getting-started.html"
```

- [ ] **Step 5: Commit**

```powershell
git add "vignettes/getting-started.Rmd"
git commit -m "docs: add getting-started vignette"
```

---

### Task 4: Component Biomass vignette

**Files:**
- Create: `vignettes/component-biomass.Rmd`

This vignette covers per-component estimation, the `rem_bark` modifier, and
Jenkins component ratios.

- [ ] **Step 1: Write the vignette**

Create `vignettes/component-biomass.Rmd`:

````rmd
---
title: "Component Biomass"
output: rmarkdown::html_vignette
vignette: >
  %\VignetteIndexEntry{Component Biomass}
  %\VignetteEngine{knitr::rmarkdown}
  %\VignetteEncoding{UTF-8}
---

```{r, include = FALSE}
knitr::opts_chunk$set(collapse = TRUE, comment = "#>")
```

```{r setup}
library(ForestBiomass)
```

`treeCalc()` returns total above-ground biomass by summing four components:
wood (stem), bark, branches, and foliage. Each component can also be computed
independently. This is useful when you need allocation patterns, want to
exclude a component for a particular tree type (e.g., no foliage on a snag),
or need per-component carbon accounting.

## Individual component functions

All four functions share the same argument structure as `treeCalc()`.

```{r}
wood <- woodCalc(
  data    = sample_trees, eval = "ung_2",
  species = "SPECIES", dbh = "DBH", height = "HEIGHT",
  output  = "biomass", decay = FALSE
)

bark <- barkCalc(
  data    = sample_trees, eval = "ung_2",
  species = "SPECIES", dbh = "DBH", height = "HEIGHT",
  output  = "biomass", decay = FALSE
)

branch <- branchCalc(
  data       = sample_trees, eval = "ung_2",
  species    = "SPECIES",    dbh = "DBH", height = "HEIGHT",
  crown_cond = "CROWN_COND", output = "biomass", decay = FALSE
)

foliage <- foliageCalc(
  data       = sample_trees, eval = "ung_2",
  species    = "SPECIES",    dbh = "DBH", height = "HEIGHT",
  crown_cond = "CROWN_COND", output = "biomass", decay = FALSE
)
```

Summing the four components reproduces the `treeCalc()` result exactly:

```{r}
agb <- suppressMessages(
  treeCalc(sample_trees, eval = "ung_2", species = "SPECIES",
           dbh = "DBH", height = "HEIGHT", crown_cond = "CROWN_COND",
           output = "biomass", decay = FALSE)
)
all.equal(wood + bark + branch + foliage, agb)
```

Component proportions vary by species and tree size:

```{r}
total <- wood + bark + branch + foliage
data.frame(
  species = sample_trees$SPECIES,
  wood_pct    = round(wood    / total * 100, 1),
  bark_pct    = round(bark    / total * 100, 1),
  branch_pct  = round(branch  / total * 100, 1),
  foliage_pct = round(foliage / total * 100, 1)
)
```

## Adjusting for partial bark loss

`barkCalc()` accepts an optional `rem_bark` column (percentage remaining,
0-100). This scales bark biomass proportionally and is useful for trees with
beetle kill, fire scorch, or logging damage.

```{r}
sample_trees$REM_BARK <- c(100, 100, 80, 60, 20, 100)

full_bark <- suppressMessages(
  barkCalc(sample_trees, eval = "ung_2", species = "SPECIES",
           dbh = "DBH", height = "HEIGHT", output = "biomass", decay = FALSE)
)
partial_bark <- suppressMessages(
  barkCalc(sample_trees, eval = "ung_2", species = "SPECIES",
           dbh = "DBH", height = "HEIGHT", rem_bark = "REM_BARK",
           output = "biomass", decay = FALSE)
)

data.frame(
  species  = sample_trees$SPECIES,
  rem_bark = sample_trees$REM_BARK,
  full_kg  = round(full_bark,    2),
  adj_kg   = round(partial_bark, 2)
)
```

## Jenkins component ratios

`jenkinsRatio()` decomposes total above-ground biomass into four component
proportions using Jenkins et al. (2003) equations. It requires only DBH and
species — no height or crown condition. Species are classified as softwood or
hardwood internally.

```{r}
ratios <- jenkinsRatio(sample_trees, dbh = "DBH", species = "SPECIES")
str(ratios)
```

Each element is a vector of ratios (one per tree). The four components sum to
approximately 1:

```{r}
wood_type <- ForestBiomass::SPECIES_CLASS$WOOD_TYPE[
  match(sample_trees$SPECIES, ForestBiomass::SPECIES_CLASS$SPECIES)
]

data.frame(
  species     = sample_trees$SPECIES,
  wood_type   = wood_type,
  foliage     = round(ratios$foliage,      3),
  coarse_root = round(ratios$coarse_roots, 3),
  stem_bark   = round(ratios$stem_bark,    3),
  stem_wood   = round(ratios$stem_wood,    3),
  check_sum   = round(ratios$foliage + ratios$coarse_roots +
                        ratios$stem_bark + ratios$stem_wood, 3)
)
```

Multiply the ratios by a Jenkins total biomass estimate to get component values:

```{r}
jenkins_total <- suppressMessages(
  treeCalc(sample_trees, eval = "jenkins", species = "SPECIES",
           dbh = "DBH", output = "biomass", decay = FALSE)
)

data.frame(
  species     = sample_trees$SPECIES,
  stem_wood   = round(ratios$stem_wood    * jenkins_total, 1),
  stem_bark   = round(ratios$stem_bark    * jenkins_total, 1),
  foliage     = round(ratios$foliage      * jenkins_total, 1),
  coarse_root = round(ratios$coarse_roots * jenkins_total, 1)
)
```
````

- [ ] **Step 2: Render the vignette to verify it builds**

```powershell
Rscript -e "rmarkdown::render('vignettes/component-biomass.Rmd')"
```

Expected: no errors; `vignettes/component-biomass.html` is created.

- [ ] **Step 3: Open and inspect the HTML**

Open `vignettes/component-biomass.html`. Check:
- `all.equal(...)` returns `TRUE`
- Component percentage table rows sum to 100
- `check_sum` column in the ratios table is all approximately 1.0
- `adj_kg` values for trees with `rem_bark < 100` are lower than `full_kg`

- [ ] **Step 4: Delete the generated HTML**

```powershell
Remove-Item "vignettes/component-biomass.html"
```

- [ ] **Step 5: Commit**

```powershell
git add "vignettes/component-biomass.Rmd"
git commit -m "docs: add component-biomass vignette"
```

---

## Self-Review

### Spec coverage
- Sample dataset with cross-compatible species ✓ (Task 1)
- Vignette infrastructure ✓ (Task 2)
- `treeCalc()` with `ung_2` ✓ (Task 3)
- All output unit options (`biomass`, `carbon`, `biomass Mg/ha`, `carbon Mg/ha`) ✓ (Task 3)
- Equation set comparison table ✓ (Task 3)
- Decay reduction with comparison table ✓ (Task 3)
- Jenkins pathway ✓ (Task 3)
- `rootCalc()` chained from `treeCalc()` ✓ (Task 3)
- Fine vs coarse root breakdown ✓ (Task 3)
- All four component functions ✓ (Task 4)
- Sum-equals-treeCalc verification ✓ (Task 4)
- Component proportions table ✓ (Task 4)
- `rem_bark` parameter ✓ (Task 4)
- `jenkinsRatio()` with full ratio table ✓ (Task 4)
- Applying ratios to Jenkins totals ✓ (Task 4)

### Placeholder scan
No TBD, TODO, "fill in", or "similar to" patterns present.

### Type consistency
- `sample_trees` column names (`SPECIES`, `DBH`, `HEIGHT`, `APPEARANCE`, `CROWN_COND`) match across all tasks and vignettes
- `REM_BARK` column is added in Task 4 before any call that references it
- `AGB` column is added in Task 3 before `rootCalc()` uses it
- `decay = FALSE` / `decay = TRUE` used consistently as logicals throughout
- `ratios$foliage`, `ratios$coarse_roots`, `ratios$stem_bark`, `ratios$stem_wood` match the return value documented in `jenkinsRatio()`
