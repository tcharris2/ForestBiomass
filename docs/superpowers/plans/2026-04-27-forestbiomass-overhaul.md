# ForestBiomass Package Overhaul Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Complete the ForestBiomass R package by adding testthat coverage for all existing functions, refactoring branchCalc to match the woodCalc pattern, and implementing the foliage and bark biomass components.

**Architecture:** All four components (wood, branch, foliage, bark) follow the same two-layer pattern: user-facing `*Calc()` functions validate inputs and dispatch via a named-list lookup table to internal `*Calculator()` functions that iterate rows and apply modifiers. Shared helpers: `ungEqn()`, `betaVal()`, `carbonMod()`, `DCRF()`, `validateSpecies()`.

**Tech Stack:** R, roxygen2 (documentation), testthat 3.x (testing), devtools (package development)

---

## File Map

### Files to Create
- `tests/testthat.R` — testthat runner (boilerplate)
- `tests/testthat/test-helpers.R` — tests for validateSpecies, ungEqn, betaVal, carbonMod, DCRF
- `tests/testthat/test-woodCalc.R` — tests for woodCalc and woodCalculator
- `tests/testthat/test-branchCalc.R` — tests for branchCalc and branchCalculator
- `tests/testthat/test-foliageCalc.R` — tests for foliageCalc and foliageCalculator
- `tests/testthat/test-barkCalc.R` — tests for barkCalc and barkCalculator
- `R/foliageCalc.R` — user-facing foliage biomass function
- `R/foliageCalculator.R` — internal foliage row iterator
- `R/barkCalc.R` — user-facing bark biomass function
- `R/barkCalculator.R` — internal bark row iterator

### Files to Modify
- `DESCRIPTION` — add Imports (rlang), Suggests (testthat), fill in Description and License
- `R/branchCalc.R` — apply same dispatch-table refactor as woodCalc
- `R/branchCalculator.R` — hoist carbonMod, replace do.call with direct call, seq_len
- `CLAUDE.md` — update implementation status table when components are complete

### Files to Delete
- `R/ungEqn1.R` — replaced by ungEqn.R (delete after branchCalc refactor in Task 3)
- `R/ungEqn2.R` — replaced by ungEqn.R (delete after branchCalc refactor in Task 3)

---

## Task 1: Set Up testthat Infrastructure

**Files:**
- Create: `tests/testthat.R`
- Modify: `DESCRIPTION`

- [ ] **Step 1: Create the test runner file**

Create `tests/testthat.R` with this exact content:
```r
library(testthat)
library(ForestBiomass)
test_check("ForestBiomass")
```

- [ ] **Step 2: Update DESCRIPTION**

Replace the contents of `DESCRIPTION` with:
```
Package: ForestBiomass
Title: Calculate Forest Biomass in Temperate Forests
Version: 0.1.0
Authors@R:
    person("Thomson", "Harris", , "thomsonharris@gmail.com", role = c("aut", "cre"))
Description: Calculates forest biomass and carbon for individual trees using
    hierarchical allometric equations. Supports wood, bark, branch, and foliage
    components using equations from Ung et al. (2008) and Lambert et al. (2005),
    with optional decay class reduction factors from Harmon et al. (2011).
License: MIT + file LICENSE
Encoding: UTF-8
Roxygen: list(markdown = TRUE)
RoxygenNote: 7.3.3
Depends:
    R (>= 3.5)
Imports:
    rlang
Suggests:
    testthat (>= 3.0.0)
Config/testthat/edition: 3
LazyData: true
```

- [ ] **Step 3: Run devtools::document() in RStudio to regenerate NAMESPACE**

In RStudio console:
```r
devtools::document()
```

- [ ] **Step 4: Verify the test infrastructure works**

In PowerShell:
```powershell
cd "C:\Users\harristc\OneDrive - UBC\MTP\Packages\ForestBiomass"
Rscript -e "devtools::test()"
```

Expected: `[ FAIL 0 | WARN 0 | SKIP 0 | PASS 0 ]` (no tests yet, but no errors)

- [ ] **Step 5: Commit**

```powershell
cd "C:\Users\harristc\OneDrive - UBC\MTP\Packages\ForestBiomass"
git add tests/testthat.R DESCRIPTION
git commit -m "chore: set up testthat infrastructure and update DESCRIPTION"
git push origin dev
```

---

## Task 2: Test Helper Functions

**Files:**
- Create: `tests/testthat/test-helpers.R`

- [ ] **Step 1: Create the helper test file**

Create `tests/testthat/test-helpers.R`:
```r
library(testthat)

# --- validateSpecies ---

test_that("validateSpecies passes silently for valid Ung species", {
  expect_silent(validateSpecies("PSEU_MEN", "ung_eqn_1"))
  expect_silent(validateSpecies("TSUG_HET", "ung_eqn_2"))
})

test_that("validateSpecies aborts for species not in Ung data", {
  expect_error(validateSpecies("INVALID_SP", "ung_eqn_1"))
})

test_that("validateSpecies aborts when Ung species used with Lambert method", {
  # PSEU_MEN is a BC species in UNG data, not in LAMBERT data
  expect_error(validateSpecies("PSEU_MEN", "lambert_eqn_1"))
})

test_that("validateSpecies handles vector of species", {
  expect_silent(validateSpecies(c("PSEU_MEN", "TSUG_HET"), "ung_eqn_1"))
})

# --- ungEqn ---

test_that("ungEqn returns correct value with DBH only (height = NULL)", {
  data <- data.frame(DBH = 10, HEIGHT = 15)
  # beta1=0.5, beta2=2.0 → 0.5 * 10^2.0 = 50
  result <- ungEqn(data, "DBH", height = NULL, c(0.5, 2.0, 1.0), 1)
  expect_equal(result, 50)
})

test_that("ungEqn returns correct value with DBH and height", {
  data <- data.frame(DBH = 10, HEIGHT = 4)
  # beta1=0.5, beta2=2.0, beta3=1.0 → 0.5 * 10^2.0 * 4^1.0 = 200
  result <- ungEqn(data, "DBH", "HEIGHT", c(0.5, 2.0, 1.0), 1)
  expect_equal(result, 200)
})

test_that("ungEqn with height = NULL equals ungEqn with beta3 = 0", {
  data <- data.frame(DBH = 17.4, HEIGHT = 10.9)
  beta_list <- c(0.0204, 2.6974, 0)
  result_no_height <- ungEqn(data, "DBH", NULL, beta_list, 1)
  expected <- 0.0204 * 17.4^2.6974
  expect_equal(result_no_height, expected, tolerance = 1e-6)
})

test_that("ungEqn iterates correctly over rows using index i", {
  data <- data.frame(DBH = c(10, 20), HEIGHT = c(5, 5))
  result_row1 <- ungEqn(data, "DBH", NULL, c(1, 2, 0), 1)
  result_row2 <- ungEqn(data, "DBH", NULL, c(1, 2, 0), 2)
  expect_equal(result_row1, 100)
  expect_equal(result_row2, 400)
})

# --- betaVal ---

test_that("betaVal returns 3 numeric values for valid species and component", {
  result <- betaVal(method = ForestBiomass::UNG_1, species = "PSEU_MEN", component = "WOOD")
  expect_length(result, 3)
  expect_type(result, "double")
})

test_that("betaVal returns correct known values for PSEU_MEN WOOD in UNG_1", {
  result <- betaVal(method = ForestBiomass::UNG_1, species = "PSEU_MEN", component = "WOOD")
  # From ung1data.R: PSEU_MEN WOOD beta1=0.0204, beta2=2.6974, beta3=NA (UNG_1 only has 2 betas)
  expect_equal(result[1], 0.0204)
  expect_equal(result[2], 2.6974)
})

test_that("betaVal returns empty for unknown species", {
  result <- betaVal(method = ForestBiomass::UNG_1, species = "INVALID", component = "WOOD")
  expect_length(result, 0)
})

# --- carbonMod ---

test_that("carbonMod returns 1 for biomass output", {
  result <- carbonMod("biomass")
  expect_equal(result, 1)
})

test_that("carbonMod returns 0.0125 for carbon output", {
  result <- carbonMod("carbon")
  expect_equal(result, 0.5 * 25 / 1000)
})

# --- DCRF ---

test_that("DCRF returns 1 for appearance code less than 3 (live tree)", {
  data <- data.frame(APPEARANCE = 1)
  expect_equal(DCRF(data, "APPEARANCE", "PSEU_MEN", 1), 1)
  data$APPEARANCE <- 2
  expect_equal(DCRF(data, "APPEARANCE", "PSEU_MEN", 1), 1)
})

test_that("DCRF returns species-specific rel1 value for appearance code 3", {
  data <- data.frame(APPEARANCE = 3)
  result <- DCRF(data, "APPEARANCE", "PSEU_MEN", 1)
  expected <- ForestBiomass::HARMON_2011$rel1[ForestBiomass::HARMON_2011$NFI_CODE == "PSEU_MEN"]
  expect_equal(result, expected)
})

test_that("DCRF returns species-specific rel4 value for appearance code >= 6", {
  data <- data.frame(APPEARANCE = 6)
  result <- DCRF(data, "APPEARANCE", "TSUG_HET", 1)
  expected <- ForestBiomass::HARMON_2011$rel4[ForestBiomass::HARMON_2011$NFI_CODE == "TSUG_HET"]
  expect_equal(result, expected)
})
```

- [ ] **Step 2: Run the helper tests**

```powershell
cd "C:\Users\harristc\OneDrive - UBC\MTP\Packages\ForestBiomass"
Rscript -e "devtools::test_active_file('tests/testthat/test-helpers.R')"
```

Expected: All tests PASS. If betaVal returns only 2 values (UNG_1 has 2 betas), adjust the length check in the betaVal test to `expect_length(result, 2)` and remove the beta3 reference.

- [ ] **Step 3: Commit**

```powershell
cd "C:\Users\harristc\OneDrive - UBC\MTP\Packages\ForestBiomass"
git add tests/testthat/test-helpers.R
git commit -m "test: add tests for helper functions"
git push origin dev
```

---

## Task 3: Test woodCalc

**Files:**
- Create: `tests/testthat/test-woodCalc.R`

- [ ] **Step 1: Create the woodCalc test file**

Create `tests/testthat/test-woodCalc.R`:
```r
library(testthat)

# Shared test fixture — two BC species with known NFI codes
wd_data <- data.frame(
  SPECIES    = c("PSEU_MEN", "TSUG_HET"),
  DBH        = c(17.4, 11.3),
  HEIGHT     = c(10.9, 9.8),
  APPEARANCE = c(1, 4)
)

# --- Input validation ---

test_that("woodCalc aborts on invalid eval method", {
  expect_error(
    woodCalc(wd_data, eval = "bad_method", species = "SPECIES", dbh = "DBH"),
    regexp = "Not Available"
  )
})

test_that("woodCalc aborts for species not in specified method", {
  bad <- data.frame(SPECIES = "INVALID_SP", DBH = 10.0)
  expect_error(
    woodCalc(bad, eval = "ung_eqn_1", species = "SPECIES", dbh = "DBH")
  )
})

test_that("woodCalc aborts when dbh column is not numeric", {
  bad <- wd_data
  bad$DBH <- as.character(bad$DBH)
  expect_error(
    suppressMessages(
      woodCalc(bad, eval = "ung_eqn_1", species = "SPECIES", dbh = "DBH")
    ),
    regexp = "numeric"
  )
})

test_that("woodCalc warns when NAs present in DBH", {
  na_data <- wd_data
  na_data$DBH[1] <- NA
  expect_message(
    suppressMessages(
      woodCalc(na_data, eval = "ung_eqn_1", species = "SPECIES",
               dbh = "DBH", output = "biomass", decay = FALSE)
    ),
    regexp = "NAs"
  )
})

# --- Output correctness ---

test_that("woodCalc returns a numeric vector with one value per row", {
  result <- suppressMessages(
    woodCalc(wd_data, eval = "ung_eqn_1", species = "SPECIES",
             dbh = "DBH", output = "biomass", decay = FALSE)
  )
  expect_type(result, "double")
  expect_length(result, nrow(wd_data))
})

test_that("woodCalc returns positive biomass values", {
  result <- suppressMessages(
    woodCalc(wd_data, eval = "ung_eqn_1", species = "SPECIES",
             dbh = "DBH", output = "biomass", decay = FALSE)
  )
  expect_true(all(result > 0))
})

test_that("woodCalc carbon output is less than biomass output", {
  biomass <- suppressMessages(
    woodCalc(wd_data, eval = "ung_eqn_1", species = "SPECIES",
             dbh = "DBH", output = "biomass", decay = FALSE)
  )
  carbon <- suppressMessages(
    woodCalc(wd_data, eval = "ung_eqn_1", species = "SPECIES",
             dbh = "DBH", output = "carbon", decay = FALSE)
  )
  expect_true(all(carbon < biomass))
})

test_that("ung_eqn_2 and ung_eqn_1 return different values", {
  eqn1 <- suppressMessages(
    woodCalc(wd_data, eval = "ung_eqn_1", species = "SPECIES",
             dbh = "DBH", output = "biomass", decay = FALSE)
  )
  eqn2 <- suppressMessages(
    woodCalc(wd_data, eval = "ung_eqn_2", species = "SPECIES",
             dbh = "DBH", height = "HEIGHT", output = "biomass", decay = FALSE)
  )
  expect_false(identical(eqn1, eqn2))
})

test_that("decay = TRUE produces different results than decay = FALSE for decayed trees", {
  # Row 2 has APPEARANCE = 4 (decay class), so decay should reduce its value
  no_decay <- suppressMessages(
    woodCalc(wd_data, eval = "ung_eqn_1", species = "SPECIES",
             dbh = "DBH", appearance = "APPEARANCE", output = "biomass", decay = FALSE)
  )
  with_decay <- suppressMessages(
    woodCalc(wd_data, eval = "ung_eqn_1", species = "SPECIES",
             dbh = "DBH", appearance = "APPEARANCE", output = "biomass", decay = TRUE)
  )
  expect_true(with_decay[2] < no_decay[2])
  expect_equal(with_decay[1], no_decay[1])  # appearance=1, no reduction
})

test_that("woodCalc returns correct known value for PSEU_MEN with ung_eqn_1", {
  single <- data.frame(SPECIES = "PSEU_MEN", DBH = 10.0)
  result <- suppressMessages(
    woodCalc(single, eval = "ung_eqn_1", species = "SPECIES",
             dbh = "DBH", output = "biomass", decay = FALSE)
  )
  # From ung1data.R: PSEU_MEN WOOD beta1=0.0204, beta2=2.6974
  expected <- 0.0204 * 10^2.6974
  expect_equal(result, expected, tolerance = 1e-6)
})
```

- [ ] **Step 2: Run woodCalc tests**

```powershell
cd "C:\Users\harristc\OneDrive - UBC\MTP\Packages\ForestBiomass"
Rscript -e "devtools::test_active_file('tests/testthat/test-woodCalc.R')"
```

Expected: All tests PASS.

- [ ] **Step 3: Commit**

```powershell
cd "C:\Users\harristc\OneDrive - UBC\MTP\Packages\ForestBiomass"
git add tests/testthat/test-woodCalc.R
git commit -m "test: add tests for woodCalc"
git push origin dev
```

---

## Task 4: Refactor branchCalc to Match woodCalc Pattern

**Files:**
- Modify: `R/branchCalc.R`
- Modify: `R/branchCalculator.R`
- Delete: `R/ungEqn1.R`
- Delete: `R/ungEqn2.R`
- Create: `tests/testthat/test-branchCalc.R`

- [ ] **Step 1: Write regression tests for branchCalc before refactoring**

Create `tests/testthat/test-branchCalc.R`:
```r
library(testthat)

br_data <- data.frame(
  SPECIES    = c("PSEU_MEN", "TSUG_HET"),
  DBH        = c(17.4, 11.3),
  HEIGHT     = c(10.9, 9.8),
  APPEARANCE = c(1, 4),
  CROWN_COND = c(1, 3)
)

# --- Input validation ---

test_that("branchCalc aborts on invalid eval method", {
  expect_error(
    branchCalc(br_data, eval = "bad_method", species = "SPECIES",
               dbh = "DBH", height = "HEIGHT", crown_cond = "CROWN_COND",
               appearance = "APPEARANCE")
  )
})

test_that("branchCalc aborts for invalid species", {
  bad <- data.frame(SPECIES = "INVALID", DBH = 10.0, HEIGHT = 10.0,
                    APPEARANCE = 1, CROWN_COND = 1)
  expect_error(
    branchCalc(bad, eval = "ung_eqn_1", species = "SPECIES",
               dbh = "DBH", height = "HEIGHT", crown_cond = "CROWN_COND",
               appearance = "APPEARANCE")
  )
})

# --- Output correctness ---

test_that("branchCalc returns numeric vector with one value per row", {
  result <- suppressMessages(
    branchCalc(br_data, eval = "ung_eqn_1", species = "SPECIES",
               dbh = "DBH", height = "HEIGHT", crown_cond = "CROWN_COND",
               appearance = "APPEARANCE", output = "biomass", decay = FALSE)
  )
  expect_type(result, "double")
  expect_length(result, nrow(br_data))
})

test_that("branchCalc carbon output is less than biomass output", {
  biomass <- suppressMessages(
    branchCalc(br_data, eval = "ung_eqn_1", species = "SPECIES",
               dbh = "DBH", height = "HEIGHT", crown_cond = "CROWN_COND",
               appearance = "APPEARANCE", output = "biomass", decay = FALSE)
  )
  carbon <- suppressMessages(
    branchCalc(br_data, eval = "ung_eqn_1", species = "SPECIES",
               dbh = "DBH", height = "HEIGHT", crown_cond = "CROWN_COND",
               appearance = "APPEARANCE", output = "carbon", decay = FALSE)
  )
  expect_true(all(carbon < biomass))
})

test_that("branchCalc returns correct known value for PSEU_MEN with ung_eqn_1", {
  single <- data.frame(SPECIES = "PSEU_MEN", DBH = 10.0, HEIGHT = 10.0,
                       APPEARANCE = 1, CROWN_COND = 1)
  result <- suppressMessages(
    branchCalc(single, eval = "ung_eqn_1", species = "SPECIES",
               dbh = "DBH", height = "HEIGHT", crown_cond = "CROWN_COND",
               appearance = "APPEARANCE", output = "biomass", decay = FALSE)
  )
  # From ung1data.R: PSEU_MEN BRANCH beta1=0.0404, beta2=2.1388
  # condition_mod=1 (CROWN_COND=1), appearance_mod=1 (APPEARANCE=1)
  expected <- 0.0404 * 10^2.1388
  expect_equal(result, expected, tolerance = 1e-6)
})
```

- [ ] **Step 2: Run regression tests to confirm current behaviour (must PASS)**

```powershell
cd "C:\Users\harristc\OneDrive - UBC\MTP\Packages\ForestBiomass"
Rscript -e "devtools::test_active_file('tests/testthat/test-branchCalc.R')"
```

Expected: All tests PASS before any refactoring.

- [ ] **Step 3: Replace branchCalc.R with the refactored version**

Overwrite `R/branchCalc.R`:
```r
#' Branch Calculation
#'
#' @description Calculates branch biomass or carbon per tree given either DBH or DBH and Height.
#' Calculations are done base on the allometric equations provided in Ung et al., 2008 or Lambert et al., 2005.
#' A species specific decay class reduction factor can be applied (Harmon et al., 2011) if desired.
#'
#' @param data User specified dataframe.
#' @param eval Which allomentic equation should be used? Default is "ung_eqn_2". Options are:
#' "ung_eqn_1", "ung_eqn_2", "lambert_eqn_1", "lambert_eqn_2".
#' @param dbh Column within data where Diameter at Breast Height (dbh) is specified.
#' @param height Optional. Required for lambert_eqn_2 or ung_eqn_2.
#' @param species Column within data where species is specified. NFI codes for species.
#' @param appearance Optional. Required when decay = TRUE.
#' @param crown_cond Column within data where crown condition is specified.
#' @param output Either "biomass" (default, kg) or "carbon" (Mg/ha).
#' @param decay Logical with default = TRUE. Should the decay class reduction factor be applied?
#'
#' @returns A vector.
#' @export
#'
#' @examples branchCalc(data = trees_data, eval = "ung_eqn_2", species = "LGTREE_NFI",
#' dbh = "DBH", height = "HEIGHT", appearance = "APPEARANCE",
#' crown_cond = "CROWN_COND", output = "biomass", decay = TRUE)

branchCalc <- function(data, eval = "ung_eqn_2",
                       dbh, height = NULL, species, appearance = NULL, crown_cond,
                       output = "biomass", decay = TRUE) {

  if (!eval %in% c("ung_eqn_1", "ung_eqn_2", "lambert_eqn_1", "lambert_eqn_2"))
    rlang::abort("Specified Method Not Available")

  validateSpecies(data[[species]], eval)

  if (!is.numeric(data[[dbh]]))
    stop("'dbh' must be a numeric vector.", call. = FALSE)

  if (any(is.na(data[[dbh]])))
    message(paste("Warning: NAs detected in", dbh))

  if (eval %in% c("lambert_eqn_2", "ung_eqn_2") && any(is.na(data[[height]])))
    message(paste("Warning: NAs detected in", height))

  message(paste("Output:", output, if (output == "biomass") "(kg)" else "(Mg/ha)"))
  if (decay) message("Species specified decay reduction factor applied (Harmon et al., 2011)")

  dispatch <- list(
    lambert_eqn_1 = list(func = ungEqn, method = ForestBiomass::LAMBERT_1),
    lambert_eqn_2 = list(func = ungEqn, method = ForestBiomass::LAMBERT_2),
    ung_eqn_1    = list(func = ungEqn, method = ForestBiomass::UNG_1),
    ung_eqn_2    = list(func = ungEqn, method = ForestBiomass::UNG_2)
  )
  sel <- dispatch[[eval]]
  branchCalculator(data, func = sel$func, method = sel$method, output = output,
                   dbh = dbh, height = height, species = species,
                   crown_cond = crown_cond, appearance = appearance, decay = decay)
}
```

- [ ] **Step 4: Replace branchCalculator.R with the refactored version**

Overwrite `R/branchCalculator.R`:
```r
#' Internal Function: Branch Calculator helper function
#'
#' @param data User specified dataframe.
#' @param method Dataframe within the package to retrieve beta values from.
#' @param output Either "biomass" or "carbon".
#' @param dbh Column within data where DBH is specified.
#' @param height Column within data where Height is specified.
#' @param species Column within data where species is specified.
#' @param crown_cond Column within data where crown condition is specified.
#' @param func Calls function ungEqn.
#' @param appearance Column within data where tree appearance is specified.
#' @param decay Logical. Should the decay class reduction factor be applied?
#'
#' @returns A vector
#' @export
#'
#' @examples NA

branchCalculator <- function(data, method, output, dbh, height = NULL, species,
                             crown_cond, func, appearance = NULL, decay = TRUE) {

  carbon_mod <- ForestBiomass::carbonMod(output)
  branch_biomass <- c()

  for (i in seq_len(nrow(data))) {
    species_spec <- data[[species]][i]

    condition_mod <- ifelse(data[[crown_cond]][i] == 5, 0.5,
                            ifelse(data[[crown_cond]][i] == 4, 0.5,
                                   ifelse(data[[crown_cond]][i] == 3, 0.5,
                                          ifelse(data[[crown_cond]][i] < 3, 1, 0))))

    appearance_mod <- ifelse(data[[appearance]][i] > 5, 0, 1)

    decay_mod <- if (decay) ForestBiomass::DCRF(data, appearance, species = species_spec, i) else 1

    beta_list <- ForestBiomass::betaVal(method = method, species = species_spec, component = "BRANCH")

    branch_biomass[i] <- func(data, dbh, height, beta_list, i) * condition_mod * appearance_mod * carbon_mod * decay_mod
  }

  return(branch_biomass)
}
```

- [ ] **Step 5: Delete ungEqn1.R and ungEqn2.R**

```powershell
cd "C:\Users\harristc\OneDrive - UBC\MTP\Packages\ForestBiomass"
Remove-Item R/ungEqn1.R
Remove-Item R/ungEqn2.R
```

- [ ] **Step 6: Run all tests to verify refactor did not break behaviour**

```powershell
cd "C:\Users\harristc\OneDrive - UBC\MTP\Packages\ForestBiomass"
Rscript -e "devtools::test()"
```

Expected: All tests PASS, including the regression tests written in Step 1.

- [ ] **Step 7: Run devtools::document() in RStudio to regenerate NAMESPACE**

In RStudio console:
```r
devtools::document()
```

- [ ] **Step 8: Commit**

```powershell
cd "C:\Users\harristc\OneDrive - UBC\MTP\Packages\ForestBiomass"
git add R/branchCalc.R R/branchCalculator.R tests/testthat/test-branchCalc.R
git rm R/ungEqn1.R R/ungEqn2.R
git commit -m "refactor: apply dispatch-table pattern to branchCalc, remove ungEqn1/ungEqn2"
git push origin dev
```

---

## Task 5: Implement foliageCalc (TDD)

Foliage depends on crown condition (dead/sparse crowns have less foliage) and tree appearance (snags have no foliage). Modifiers follow the branch pattern. Component name in beta data: `"FOLIAGE"`.

**Files:**
- Create: `tests/testthat/test-foliageCalc.R`
- Create: `R/foliageCalculator.R`
- Create: `R/foliageCalc.R`

- [ ] **Step 1: Write failing tests for foliageCalc**

Create `tests/testthat/test-foliageCalc.R`:
```r
library(testthat)

fo_data <- data.frame(
  SPECIES    = c("PSEU_MEN", "TSUG_HET"),
  DBH        = c(17.4, 11.3),
  HEIGHT     = c(10.9, 9.8),
  APPEARANCE = c(1, 4),
  CROWN_COND = c(1, 3)
)

test_that("foliageCalc aborts on invalid eval method", {
  expect_error(
    foliageCalc(fo_data, eval = "bad_method", species = "SPECIES",
                dbh = "DBH", crown_cond = "CROWN_COND")
  )
})

test_that("foliageCalc aborts for invalid species", {
  bad <- data.frame(SPECIES = "INVALID", DBH = 10.0, HEIGHT = 10.0,
                    APPEARANCE = 1, CROWN_COND = 1)
  expect_error(
    foliageCalc(bad, eval = "ung_eqn_1", species = "SPECIES",
                dbh = "DBH", crown_cond = "CROWN_COND")
  )
})

test_that("foliageCalc returns numeric vector with one value per row", {
  result <- suppressMessages(
    foliageCalc(fo_data, eval = "ung_eqn_1", species = "SPECIES",
                dbh = "DBH", crown_cond = "CROWN_COND",
                appearance = "APPEARANCE", output = "biomass", decay = FALSE)
  )
  expect_type(result, "double")
  expect_length(result, nrow(fo_data))
})

test_that("foliageCalc returns non-negative values", {
  result <- suppressMessages(
    foliageCalc(fo_data, eval = "ung_eqn_1", species = "SPECIES",
                dbh = "DBH", crown_cond = "CROWN_COND",
                appearance = "APPEARANCE", output = "biomass", decay = FALSE)
  )
  expect_true(all(result >= 0))
})

test_that("foliageCalc carbon output is less than biomass output", {
  biomass <- suppressMessages(
    foliageCalc(fo_data, eval = "ung_eqn_1", species = "SPECIES",
                dbh = "DBH", crown_cond = "CROWN_COND",
                appearance = "APPEARANCE", output = "biomass", decay = FALSE)
  )
  carbon <- suppressMessages(
    foliageCalc(fo_data, eval = "ung_eqn_1", species = "SPECIES",
                dbh = "DBH", crown_cond = "CROWN_COND",
                appearance = "APPEARANCE", output = "carbon", decay = FALSE)
  )
  expect_true(all(carbon < biomass))
})

test_that("foliageCalc returns 0 for snag (appearance > 5)", {
  snag <- data.frame(SPECIES = "PSEU_MEN", DBH = 17.4, HEIGHT = 10.9,
                     APPEARANCE = 6, CROWN_COND = 1)
  result <- suppressMessages(
    foliageCalc(snag, eval = "ung_eqn_1", species = "SPECIES",
                dbh = "DBH", crown_cond = "CROWN_COND",
                appearance = "APPEARANCE", output = "biomass", decay = FALSE)
  )
  expect_equal(result, 0)
})

test_that("foliageCalc returns correct known value for PSEU_MEN ung_eqn_1", {
  single <- data.frame(SPECIES = "PSEU_MEN", DBH = 10.0, HEIGHT = 10.0,
                       APPEARANCE = 1, CROWN_COND = 1)
  result <- suppressMessages(
    foliageCalc(single, eval = "ung_eqn_1", species = "SPECIES",
                dbh = "DBH", crown_cond = "CROWN_COND",
                appearance = "APPEARANCE", output = "biomass", decay = FALSE)
  )
  # From ung1data.R: PSEU_MEN FOLIAGE beta1=0.1233, beta2=1.6636
  # condition_mod=1 (CROWN_COND=1), appearance_mod=1 (APPEARANCE=1)
  expected <- 0.1233 * 10^1.6636
  expect_equal(result, expected, tolerance = 1e-6)
})
```

- [ ] **Step 2: Run tests — they must FAIL (foliageCalc does not exist yet)**

```powershell
cd "C:\Users\harristc\OneDrive - UBC\MTP\Packages\ForestBiomass"
Rscript -e "devtools::test_active_file('tests/testthat/test-foliageCalc.R')"
```

Expected: FAIL with "could not find function foliageCalc"

- [ ] **Step 3: Create foliageCalculator.R**

Create `R/foliageCalculator.R`:
```r
#' Internal Function: Foliage Calculator helper function
#'
#' @param data User specified dataframe.
#' @param method Dataframe within the package to retrieve beta values from.
#' @param output Either "biomass" or "carbon".
#' @param dbh Column within data where DBH is specified.
#' @param height Column within data where Height is specified.
#' @param species Column within data where species is specified.
#' @param crown_cond Column within data where crown condition is specified.
#' @param func Calls function ungEqn.
#' @param appearance Column within data where tree appearance is specified.
#' @param decay Logical. Should the decay class reduction factor be applied?
#'
#' @returns A vector
#' @export
#'
#' @examples NA

foliageCalculator <- function(data, method, output, dbh, height = NULL, species,
                              crown_cond, func, appearance = NULL, decay = TRUE) {

  carbon_mod <- ForestBiomass::carbonMod(output)
  foliage_biomass <- c()

  for (i in seq_len(nrow(data))) {
    species_spec <- data[[species]][i]

    condition_mod <- ifelse(data[[crown_cond]][i] == 5, 0.5,
                            ifelse(data[[crown_cond]][i] == 4, 0.5,
                                   ifelse(data[[crown_cond]][i] == 3, 0.5,
                                          ifelse(data[[crown_cond]][i] < 3, 1, 0))))

    appearance_mod <- ifelse(data[[appearance]][i] > 5, 0, 1)

    decay_mod <- if (decay) ForestBiomass::DCRF(data, appearance, species = species_spec, i) else 1

    beta_list <- ForestBiomass::betaVal(method = method, species = species_spec, component = "FOLIAGE")

    foliage_biomass[i] <- func(data, dbh, height, beta_list, i) * condition_mod * appearance_mod * carbon_mod * decay_mod
  }

  return(foliage_biomass)
}
```

- [ ] **Step 4: Create foliageCalc.R**

Create `R/foliageCalc.R`:
```r
#' Foliage Calculation
#'
#' @description Calculates foliage biomass or carbon per tree given either DBH or DBH and Height.
#' Calculations are done base on the allometric equations provided in Ung et al., 2008 or Lambert et al., 2005.
#' A species specific decay class reduction factor can be applied (Harmon et al., 2011) if desired.
#'
#' @param data User specified dataframe.
#' @param eval Which allomentic equation should be used? Default is "ung_eqn_2". Options are:
#' "ung_eqn_1", "ung_eqn_2", "lambert_eqn_1", "lambert_eqn_2".
#' @param dbh Column within data where Diameter at Breast Height (dbh) is specified.
#' @param height Optional. Required for lambert_eqn_2 or ung_eqn_2.
#' @param species Column within data where species is specified. NFI codes for species.
#' @param appearance Optional. Required when decay = TRUE.
#' @param crown_cond Column within data where crown condition is specified.
#' @param output Either "biomass" (default, kg) or "carbon" (Mg/ha).
#' @param decay Logical with default = TRUE. Should the decay class reduction factor be applied?
#'
#' @returns A vector.
#' @export
#'
#' @examples foliageCalc(data = trees_data, eval = "ung_eqn_2", species = "LGTREE_NFI",
#' dbh = "DBH", height = "HEIGHT", appearance = "APPEARANCE",
#' crown_cond = "CROWN_COND", output = "biomass", decay = TRUE)

foliageCalc <- function(data, eval = "ung_eqn_2",
                        dbh, height = NULL, species, appearance = NULL, crown_cond,
                        output = "biomass", decay = TRUE) {

  if (!eval %in% c("ung_eqn_1", "ung_eqn_2", "lambert_eqn_1", "lambert_eqn_2"))
    rlang::abort("Specified Method Not Available")

  validateSpecies(data[[species]], eval)

  if (!is.numeric(data[[dbh]]))
    stop("'dbh' must be a numeric vector.", call. = FALSE)

  if (any(is.na(data[[dbh]])))
    message(paste("Warning: NAs detected in", dbh))

  if (eval %in% c("lambert_eqn_2", "ung_eqn_2") && any(is.na(data[[height]])))
    message(paste("Warning: NAs detected in", height))

  message(paste("Output:", output, if (output == "biomass") "(kg)" else "(Mg/ha)"))
  if (decay) message("Species specified decay reduction factor applied (Harmon et al., 2011)")

  dispatch <- list(
    lambert_eqn_1 = list(func = ungEqn, method = ForestBiomass::LAMBERT_1),
    lambert_eqn_2 = list(func = ungEqn, method = ForestBiomass::LAMBERT_2),
    ung_eqn_1    = list(func = ungEqn, method = ForestBiomass::UNG_1),
    ung_eqn_2    = list(func = ungEqn, method = ForestBiomass::UNG_2)
  )
  sel <- dispatch[[eval]]
  foliageCalculator(data, func = sel$func, method = sel$method, output = output,
                    dbh = dbh, height = height, species = species,
                    crown_cond = crown_cond, appearance = appearance, decay = decay)
}
```

- [ ] **Step 5: Run tests — they must now PASS**

```powershell
cd "C:\Users\harristc\OneDrive - UBC\MTP\Packages\ForestBiomass"
Rscript -e "devtools::test_active_file('tests/testthat/test-foliageCalc.R')"
```

Expected: All tests PASS.

- [ ] **Step 6: Run the full test suite to check for regressions**

```powershell
Rscript -e "devtools::test()"
```

Expected: All tests PASS.

- [ ] **Step 7: Run devtools::document() in RStudio**

In RStudio console:
```r
devtools::document()
```

- [ ] **Step 8: Commit**

```powershell
cd "C:\Users\harristc\OneDrive - UBC\MTP\Packages\ForestBiomass"
git add R/foliageCalc.R R/foliageCalculator.R tests/testthat/test-foliageCalc.R
git commit -m "feat: implement foliageCalc with tests"
git push origin dev
```

---

## Task 6: Implement barkCalc (TDD)

Bark biomass is modified by the percentage of bark remaining (`rem_bark`, 0–100). For a fully-barked live tree `rem_bark = 100`; for a stripped snag it approaches 0. Component name in beta data: `"BARK"`.

**Files:**
- Create: `tests/testthat/test-barkCalc.R`
- Create: `R/barkCalculator.R`
- Create: `R/barkCalc.R`

- [ ] **Step 1: Write failing tests for barkCalc**

Create `tests/testthat/test-barkCalc.R`:
```r
library(testthat)

bk_data <- data.frame(
  SPECIES    = c("PSEU_MEN", "TSUG_HET"),
  DBH        = c(17.4, 11.3),
  HEIGHT     = c(10.9, 9.8),
  APPEARANCE = c(1, 4),
  REM_BARK   = c(100, 60)
)

test_that("barkCalc aborts on invalid eval method", {
  expect_error(
    barkCalc(bk_data, eval = "bad_method", species = "SPECIES", dbh = "DBH")
  )
})

test_that("barkCalc aborts for invalid species", {
  bad <- data.frame(SPECIES = "INVALID", DBH = 10.0, APPEARANCE = 1, REM_BARK = 100)
  expect_error(
    barkCalc(bad, eval = "ung_eqn_1", species = "SPECIES", dbh = "DBH")
  )
})

test_that("barkCalc returns numeric vector with one value per row", {
  result <- suppressMessages(
    barkCalc(bk_data, eval = "ung_eqn_1", species = "SPECIES",
             dbh = "DBH", rem_bark = "REM_BARK", output = "biomass", decay = FALSE)
  )
  expect_type(result, "double")
  expect_length(result, nrow(bk_data))
})

test_that("barkCalc returns non-negative values", {
  result <- suppressMessages(
    barkCalc(bk_data, eval = "ung_eqn_1", species = "SPECIES",
             dbh = "DBH", rem_bark = "REM_BARK", output = "biomass", decay = FALSE)
  )
  expect_true(all(result >= 0))
})

test_that("barkCalc carbon output is less than biomass output", {
  biomass <- suppressMessages(
    barkCalc(bk_data, eval = "ung_eqn_1", species = "SPECIES",
             dbh = "DBH", rem_bark = "REM_BARK", output = "biomass", decay = FALSE)
  )
  carbon <- suppressMessages(
    barkCalc(bk_data, eval = "ung_eqn_1", species = "SPECIES",
             dbh = "DBH", rem_bark = "REM_BARK", output = "carbon", decay = FALSE)
  )
  expect_true(all(carbon < biomass))
})

test_that("barkCalc with rem_bark = 50 returns half the value of rem_bark = 100", {
  full  <- data.frame(SPECIES = "PSEU_MEN", DBH = 10.0, REM_BARK = 100, APPEARANCE = 1)
  half  <- data.frame(SPECIES = "PSEU_MEN", DBH = 10.0, REM_BARK = 50,  APPEARANCE = 1)
  r_full <- suppressMessages(
    barkCalc(full, eval = "ung_eqn_1", species = "SPECIES",
             dbh = "DBH", rem_bark = "REM_BARK", output = "biomass", decay = FALSE)
  )
  r_half <- suppressMessages(
    barkCalc(half, eval = "ung_eqn_1", species = "SPECIES",
             dbh = "DBH", rem_bark = "REM_BARK", output = "biomass", decay = FALSE)
  )
  expect_equal(r_half, r_full * 0.5, tolerance = 1e-6)
})

test_that("barkCalc returns correct known value for PSEU_MEN ung_eqn_1 full bark", {
  single <- data.frame(SPECIES = "PSEU_MEN", DBH = 10.0, REM_BARK = 100, APPEARANCE = 1)
  result <- suppressMessages(
    barkCalc(single, eval = "ung_eqn_1", species = "SPECIES",
             dbh = "DBH", rem_bark = "REM_BARK", output = "biomass", decay = FALSE)
  )
  # From ung1data.R: PSEU_MEN BARK beta1=0.0069, beta2=2.5462
  # rem_bark modifier = 100/100 = 1
  expected <- 0.0069 * 10^2.5462
  expect_equal(result, expected, tolerance = 1e-6)
})
```

- [ ] **Step 2: Run tests — they must FAIL (barkCalc does not exist yet)**

```powershell
cd "C:\Users\harristc\OneDrive - UBC\MTP\Packages\ForestBiomass"
Rscript -e "devtools::test_active_file('tests/testthat/test-barkCalc.R')"
```

Expected: FAIL with "could not find function barkCalc"

- [ ] **Step 3: Create barkCalculator.R**

Create `R/barkCalculator.R`:
```r
#' Internal Function: Bark Calculator helper function
#'
#' @param data User specified dataframe.
#' @param method Dataframe within the package to retrieve beta values from.
#' @param output Either "biomass" or "carbon".
#' @param dbh Column within data where DBH is specified.
#' @param height Column within data where Height is specified.
#' @param species Column within data where species is specified.
#' @param rem_bark Column within data where remaining bark percentage (0-100) is specified.
#' @param func Calls function ungEqn.
#' @param appearance Column within data where tree appearance is specified.
#' @param decay Logical. Should the decay class reduction factor be applied?
#'
#' @returns A vector
#' @export
#'
#' @examples NA

barkCalculator <- function(data, method, output, dbh, height = NULL, species,
                           rem_bark = NULL, func, appearance = NULL, decay = TRUE) {

  carbon_mod <- ForestBiomass::carbonMod(output)
  bark_biomass <- c()

  for (i in seq_len(nrow(data))) {
    species_spec <- data[[species]][i]

    bark_mod <- if (!is.null(rem_bark)) data[[rem_bark]][i] / 100 else 1

    decay_mod <- if (decay) ForestBiomass::DCRF(data, appearance, species = species_spec, i) else 1

    beta_list <- ForestBiomass::betaVal(method = method, species = species_spec, component = "BARK")

    bark_biomass[i] <- func(data, dbh, height, beta_list, i) * bark_mod * carbon_mod * decay_mod
  }

  return(bark_biomass)
}
```

- [ ] **Step 4: Create barkCalc.R**

Create `R/barkCalc.R`:
```r
#' Bark Calculation
#'
#' @description Calculates bark biomass or carbon per tree given either DBH or DBH and Height.
#' Calculations are done base on the allometric equations provided in Ung et al., 2008 or Lambert et al., 2005.
#' A species specific decay class reduction factor can be applied (Harmon et al., 2011) if desired.
#'
#' @param data User specified dataframe.
#' @param eval Which allomentic equation should be used? Default is "ung_eqn_2". Options are:
#' "ung_eqn_1", "ung_eqn_2", "lambert_eqn_1", "lambert_eqn_2".
#' @param dbh Column within data where Diameter at Breast Height (dbh) is specified.
#' @param height Optional. Required for lambert_eqn_2 or ung_eqn_2.
#' @param species Column within data where species is specified. NFI codes for species.
#' @param appearance Optional. Required when decay = TRUE.
#' @param rem_bark Optional. Column within data where remaining bark percentage (0-100) is specified.
#' @param output Either "biomass" (default, kg) or "carbon" (Mg/ha).
#' @param decay Logical with default = TRUE. Should the decay class reduction factor be applied?
#'
#' @returns A vector.
#' @export
#'
#' @examples barkCalc(data = trees_data, eval = "ung_eqn_2", species = "LGTREE_NFI",
#' dbh = "DBH", height = "HEIGHT", appearance = "APPEARANCE",
#' rem_bark = "REM_BARK", output = "biomass", decay = TRUE)

barkCalc <- function(data, eval = "ung_eqn_2",
                     dbh, height = NULL, species, appearance = NULL, rem_bark = NULL,
                     output = "biomass", decay = TRUE) {

  if (!eval %in% c("ung_eqn_1", "ung_eqn_2", "lambert_eqn_1", "lambert_eqn_2"))
    rlang::abort("Specified Method Not Available")

  validateSpecies(data[[species]], eval)

  if (!is.numeric(data[[dbh]]))
    stop("'dbh' must be a numeric vector.", call. = FALSE)

  if (any(is.na(data[[dbh]])))
    message(paste("Warning: NAs detected in", dbh))

  if (eval %in% c("lambert_eqn_2", "ung_eqn_2") && any(is.na(data[[height]])))
    message(paste("Warning: NAs detected in", height))

  message(paste("Output:", output, if (output == "biomass") "(kg)" else "(Mg/ha)"))
  if (decay) message("Species specified decay reduction factor applied (Harmon et al., 2011)")

  dispatch <- list(
    lambert_eqn_1 = list(func = ungEqn, method = ForestBiomass::LAMBERT_1),
    lambert_eqn_2 = list(func = ungEqn, method = ForestBiomass::LAMBERT_2),
    ung_eqn_1    = list(func = ungEqn, method = ForestBiomass::UNG_1),
    ung_eqn_2    = list(func = ungEqn, method = ForestBiomass::UNG_2)
  )
  sel <- dispatch[[eval]]
  barkCalculator(data, func = sel$func, method = sel$method, output = output,
                 dbh = dbh, height = height, species = species,
                 rem_bark = rem_bark, appearance = appearance, decay = decay)
}
```

- [ ] **Step 5: Run tests — they must now PASS**

```powershell
cd "C:\Users\harristc\OneDrive - UBC\MTP\Packages\ForestBiomass"
Rscript -e "devtools::test_active_file('tests/testthat/test-barkCalc.R')"
```

Expected: All tests PASS.

- [ ] **Step 6: Run the full test suite**

```powershell
Rscript -e "devtools::test()"
```

Expected: All tests PASS.

- [ ] **Step 7: Run devtools::document() in RStudio**

In RStudio console:
```r
devtools::document()
```

- [ ] **Step 8: Commit**

```powershell
cd "C:\Users\harristc\OneDrive - UBC\MTP\Packages\ForestBiomass"
git add R/barkCalc.R R/barkCalculator.R tests/testthat/test-barkCalc.R
git commit -m "feat: implement barkCalc with tests"
git push origin dev
```

---

## Task 7: Update CLAUDE.md and Final Polish

**Files:**
- Modify: `CLAUDE.md`

- [ ] **Step 1: Update the implementation status table in CLAUDE.md**

Replace the status table with:
```markdown
| Component | User function       | Status   |
|-----------|---------------------|----------|
| Wood      | `woodCalc()`        | Complete |
| Branches  | `branchCalc()`      | Complete |
| Foliage   | `foliageCalc()`     | Complete |
| Bark      | `barkCalc()`        | Complete |
```

Also remove the note about `ungEqn1`/`ungEqn2` since they will have been deleted.

- [ ] **Step 2: Run the full test suite one final time**

```powershell
cd "C:\Users\harristc\OneDrive - UBC\MTP\Packages\ForestBiomass"
Rscript -e "devtools::test()"
```

Expected: All tests PASS with zero failures and zero warnings.

- [ ] **Step 3: Commit and push**

```powershell
cd "C:\Users\harristc\OneDrive - UBC\MTP\Packages\ForestBiomass"
git add CLAUDE.md
git commit -m "docs: update CLAUDE.md to reflect completed implementation"
git push origin dev
```
