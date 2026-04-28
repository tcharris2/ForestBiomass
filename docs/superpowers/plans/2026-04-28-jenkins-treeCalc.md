# Jenkins et al. 2003 — treeCalc() Integration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add `eval = "jenkins"` to `treeCalc()` using Jenkins et al. (2003) total above-ground biomass equations, and rename all existing `eval` strings to remove the `"_eqn_"` substring.

**Architecture:** Two new data objects (`JENKINS`, `JENKINS_GROUPS`) feed a new internal `jenkinsCalculator()`. `treeCalc()` gains a Jenkins dispatch branch alongside the existing Ung/Lambert component-sum pathway. The eval string rename is a breaking change applied atomically across all five `*Calc()` functions, `resolveMethod()`, and all test files.

**Tech Stack:** R, roxygen2, testthat 3.x, devtools

---

## File Map

### Files to Create
- `data_R/jenkinsdata.R` — builds `JENKINS` coefficient data object
- `data_R/jenkinsgroupsdata.R` — builds `JENKINS_GROUPS` mapping data object
- `R/JENKINS.R` — roxygen docs for `JENKINS` data object
- `R/JENKINS_GROUPS.R` — roxygen docs for `JENKINS_GROUPS` data object
- `R/jenkinsCalculator.R` — internal per-row Jenkins calculation
- `tests/testthat/test-treeCalc-jenkins.R` — tests for Jenkins pathway

### Files to Modify
- `R/woodCalc.R` — rename eval strings
- `R/branchCalc.R` — rename eval strings
- `R/foliageCalc.R` — rename eval strings
- `R/barkCalc.R` — rename eval strings
- `R/resolveMethod.R` — rename dispatch table keys
- `R/treeCalc.R` — rename eval strings, add jenkins pathway, remove include_root, make crown_cond NULL-defaulted
- `tests/testthat/test-woodCalc.R` — rename eval strings
- `tests/testthat/test-branchCalc.R` — rename eval strings
- `tests/testthat/test-foliageCalc.R` — rename eval strings
- `tests/testthat/test-barkCalc.R` — rename eval strings

---

## Task 1: Create JENKINS and JENKINS_GROUPS Data Objects

**Files:**
- Create: `data_R/jenkinsdata.R`
- Create: `data_R/jenkinsgroupsdata.R`
- Create: `R/JENKINS.R`
- Create: `R/JENKINS_GROUPS.R`

- [ ] **Step 1: Create `data_R/jenkinsdata.R`**

```r
# Coefficients for Jenkins et al. (2003) total above-ground biomass equation:
# bm = exp(BETA_0 + BETA_1 * ln(DBH)), where bm is in kg and DBH is in cm.
# "Mixed softwood" is an in-house addition: arithmetic mean of beta coefficients
# across Cedar/larch, Douglas-fir, True fir/hemlock, Pine, and Spruce.

JENKINS <- data.frame(
  SPECIES_GROUP = c("Cedar/larch", "Douglas-fir", "True fir/hemlock", "Pine", "Spruce",
                    "Aspen/alder/cottonwood/willow", "Soft maple/birch", "Mixed hardwood",
                    "Hard maple/oak/hickory/beech", "Juniper/oak/mesquite", "Mixed softwood"),
  BETA_0 = c(-2.0336, -2.2304, -2.5384, -2.5356, -2.0773,
              -2.2094, -1.9123, -2.4800, -2.0127, -0.7152, -2.2831),
  BETA_1 = c(2.2592, 2.4435, 2.4814, 2.4249, 2.3323,
              2.3867, 2.3651, 2.4835, 2.4342, 1.7029, 2.3883)
)
```

- [ ] **Step 2: Create `data_R/jenkinsgroupsdata.R`**

```r
# Maps NFI species codes to Jenkins et al. (2003) species groups.
# Coverage: union of Ung and Lambert dataset species, excluding ambiguous catch-alls.

JENKINS_GROUPS <- data.frame(
  SPECIES = c("PICE_MAR", "PSEU_MEN", "PICE_ENG", "PINU_CON", "ABIE_AMA", "ALNU_RUB",
              "POPU_TRI", "PICE_SIT", "ABIE_LAS", "POPU_TRE", "TSUG_HET", "THUJ_PLI",
              "BETU_PAP", "PICE_GLA", "ABIE_BAL", "POPU_BAL", "TILI_AME", "FAGU_GRA",
              "FRAX_NIG", "PRUN_SER", "TSUG_CAN", "JUNI_VIR", "THUJ_OCC", "PINU_STR",
              "BETU_POP", "CARY_SPP", "OSTR_VIR", "PINU_BAN", "POPU_GRA", "FRAX_PEN",
              "ACER_RUB", "QUER_RUB", "PINU_RES", "PICE_RUB", "ACER_SAC", "ACER_SAH",
              "LARI_LAR", "FRAX_AME", "ULMU_AME", "QUER_ALB", "BETU_ALL",
              "GENH_SPP", "GENC_SPP"),
  SPECIES_GROUP = c("Spruce", "Douglas-fir", "Spruce", "Pine", "True fir/hemlock",
                    "Aspen/alder/cottonwood/willow", "Aspen/alder/cottonwood/willow",
                    "Spruce", "True fir/hemlock", "Aspen/alder/cottonwood/willow",
                    "True fir/hemlock", "Cedar/larch", "Soft maple/birch", "Spruce",
                    "True fir/hemlock", "Aspen/alder/cottonwood/willow", "Mixed hardwood",
                    "Hard maple/oak/hickory/beech", "Mixed hardwood", "Mixed hardwood",
                    "True fir/hemlock", "Cedar/larch", "Cedar/larch", "Pine",
                    "Soft maple/birch", "Hard maple/oak/hickory/beech", "Mixed hardwood",
                    "Pine", "Aspen/alder/cottonwood/willow", "Mixed hardwood",
                    "Soft maple/birch", "Hard maple/oak/hickory/beech", "Pine",
                    "Spruce", "Soft maple/birch", "Hard maple/oak/hickory/beech",
                    "Cedar/larch", "Mixed hardwood", "Mixed hardwood",
                    "Hard maple/oak/hickory/beech", "Soft maple/birch",
                    "Mixed hardwood", "Mixed softwood")
)
```

- [ ] **Step 3: Create `R/JENKINS.R`**

```r
#' Data: Jenkins et al. (2003) total above-ground biomass equation coefficients
#'
#' @format
#' A data frame with 11 rows and 3 columns:
#' \describe{
#'   \item{SPECIES_GROUP}{Jenkins species group name}
#'   \item{BETA_0}{Intercept coefficient}
#'   \item{BETA_1}{Slope coefficient}
#' }
#' @source Values from Jenkins et al. (2003) National-scale biomass estimators for
#' United States tree species. Forest Science, 49(1): 12-35. "Mixed softwood" is
#' an in-house addition: arithmetic mean of beta coefficients across Cedar/larch,
#' Douglas-fir, True fir/hemlock, Pine, and Spruce.
"JENKINS"
```

- [ ] **Step 4: Create `R/JENKINS_GROUPS.R`**

```r
#' Data: NFI species code to Jenkins species group mapping
#'
#' @format
#' A data frame with 43 rows and 2 columns:
#' \describe{
#'   \item{SPECIES}{NFI species code}
#'   \item{SPECIES_GROUP}{Corresponding Jenkins et al. (2003) species group}
#' }
#' @source Species group assignments based on Jenkins et al. (2003) National-scale
#' biomass estimators for United States tree species. Forest Science, 49(1): 12-35.
"JENKINS_GROUPS"
```

- [ ] **Step 5: Build and save the data objects**

In RStudio console:
```r
source("data_R/jenkinsdata.R")
source("data_R/jenkinsgroupsdata.R")
usethis::use_data(JENKINS, JENKINS_GROUPS, overwrite = TRUE)
```

Expected: `✔ Setting active project to '...'`, two `.rda` files created in `data/`.

- [ ] **Step 6: Regenerate documentation**

In RStudio console:
```r
devtools::document()
```

Expected: `JENKINS` and `JENKINS_GROUPS` appear in `NAMESPACE` and `.Rd` files generated.

- [ ] **Step 7: Verify data loads correctly**

In RStudio console:
```r
devtools::load_all()
head(ForestBiomass::JENKINS)
head(ForestBiomass::JENKINS_GROUPS)
```

Expected: both objects print without error. `JENKINS` has 11 rows, `JENKINS_GROUPS` has 43 rows.

- [ ] **Step 8: Commit**

```powershell
cd "C:\Users\harristc\OneDrive - UBC\MTP\Packages\ForestBiomass"
git add data_R/jenkinsdata.R data_R/jenkinsgroupsdata.R R/JENKINS.R R/JENKINS_GROUPS.R data/JENKINS.rda data/JENKINS_GROUPS.rda NAMESPACE man/JENKINS.Rd man/JENKINS_GROUPS.Rd
git commit -m "feat: add JENKINS and JENKINS_GROUPS data objects"
```

---

## Task 2: Rename Eval Strings (Breaking Change)

Rename `"ung_eqn_1"` → `"ung_1"`, `"ung_eqn_2"` → `"ung_2"`, `"lambert_eqn_1"` → `"lambert_1"`, `"lambert_eqn_2"` → `"lambert_2"` across all source files and tests. `treeCalc.R` is excluded here — it will be fully replaced in Task 4.

**Files:**
- Modify: `R/woodCalc.R`
- Modify: `R/branchCalc.R`
- Modify: `R/foliageCalc.R`
- Modify: `R/barkCalc.R`
- Modify: `R/resolveMethod.R`
- Modify: `tests/testthat/test-woodCalc.R`
- Modify: `tests/testthat/test-branchCalc.R`
- Modify: `tests/testthat/test-foliageCalc.R`
- Modify: `tests/testthat/test-barkCalc.R`

- [ ] **Step 1: Update `R/woodCalc.R`**

Replace:
```r
  if (!eval %in% c("ung_eqn_1", "ung_eqn_2", "lambert_eqn_1", "lambert_eqn_2"))
```
With:
```r
  if (!eval %in% c("ung_1", "ung_2", "lambert_1", "lambert_2"))
```

Replace:
```r
  if (eval %in% c("lambert_eqn_2", "ung_eqn_2")) {
```
With:
```r
  if (eval %in% c("lambert_2", "ung_2")) {
```

- [ ] **Step 2: Update `R/branchCalc.R`**

Replace:
```r
  if (!eval %in% c("ung_eqn_1", "ung_eqn_2", "lambert_eqn_1", "lambert_eqn_2"))
```
With:
```r
  if (!eval %in% c("ung_1", "ung_2", "lambert_1", "lambert_2"))
```

Replace:
```r
  if (eval %in% c("lambert_eqn_2", "ung_eqn_2")) {
```
With:
```r
  if (eval %in% c("lambert_2", "ung_2")) {
```

- [ ] **Step 3: Update `R/foliageCalc.R`**

Replace:
```r
  if (!eval %in% c("ung_eqn_1", "ung_eqn_2", "lambert_eqn_1", "lambert_eqn_2"))
```
With:
```r
  if (!eval %in% c("ung_1", "ung_2", "lambert_1", "lambert_2"))
```

Replace:
```r
  if (eval %in% c("lambert_eqn_2", "ung_eqn_2") && any(is.na(data[[height]])))
```
With:
```r
  if (eval %in% c("lambert_2", "ung_2") && any(is.na(data[[height]])))
```

- [ ] **Step 4: Update `R/barkCalc.R`**

Replace:
```r
  if (!eval %in% c("ung_eqn_1", "ung_eqn_2", "lambert_eqn_1", "lambert_eqn_2"))
```
With:
```r
  if (!eval %in% c("ung_1", "ung_2", "lambert_1", "lambert_2"))
```

Replace:
```r
  if (eval %in% c("lambert_eqn_2", "ung_eqn_2") && any(is.na(data[[height]])))
```
With:
```r
  if (eval %in% c("lambert_2", "ung_2") && any(is.na(data[[height]])))
```

- [ ] **Step 5: Update `R/resolveMethod.R`**

Overwrite with:
```r
#' Internal: Resolve allometric method, equation function, and height for dispatch
#'
#' @param eval The allometric equation method string.
#' @param height Column name for height, or NULL.
#'
#' @returns A list with func, method, and resolved height (NULL for DBH-only equations).
#' @keywords internal

resolveMethod <- function(eval, height) {
  methods <- list(
    lambert_1 = list(func = ungEqn, method = ForestBiomass::LAMBERT_1),
    lambert_2 = list(func = ungEqn, method = ForestBiomass::LAMBERT_2),
    ung_1    = list(func = ungEqn, method = ForestBiomass::UNG_1),
    ung_2    = list(func = ungEqn, method = ForestBiomass::UNG_2)
  )
  sel <- methods[[eval]]
  sel$height <- if (eval %in% c("ung_1", "lambert_1")) NULL else height
  sel
}
```

- [ ] **Step 6: Update `tests/testthat/test-woodCalc.R`**

Replace every occurrence of `"ung_eqn_1"` with `"ung_1"` and `"ung_eqn_2"` with `"ung_2"`.

- [ ] **Step 7: Update `tests/testthat/test-branchCalc.R`**

Replace every occurrence of `"ung_eqn_1"` with `"ung_1"`.

- [ ] **Step 8: Update `tests/testthat/test-foliageCalc.R`**

Replace every occurrence of `"ung_eqn_1"` with `"ung_1"`.

- [ ] **Step 9: Update `tests/testthat/test-barkCalc.R`**

Replace every occurrence of `"ung_eqn_1"` with `"ung_1"`.

- [ ] **Step 10: Run full test suite — all must pass**

```powershell
cd "C:\Users\harristc\OneDrive - UBC\MTP\Packages\ForestBiomass"
Rscript -e "devtools::test()"
```

Expected: all existing tests PASS with no failures.

- [ ] **Step 11: Commit**

```powershell
cd "C:\Users\harristc\OneDrive - UBC\MTP\Packages\ForestBiomass"
git add R/woodCalc.R R/branchCalc.R R/foliageCalc.R R/barkCalc.R R/resolveMethod.R
git add tests/testthat/test-woodCalc.R tests/testthat/test-branchCalc.R
git add tests/testthat/test-foliageCalc.R tests/testthat/test-barkCalc.R
git commit -m "refactor: rename eval strings to remove _eqn_ substring (breaking change)"
```

---

## Task 3: Write Failing Jenkins Tests

**Files:**
- Create: `tests/testthat/test-treeCalc-jenkins.R`

- [ ] **Step 1: Create `tests/testthat/test-treeCalc-jenkins.R`**

```r
library(testthat)

jk_data <- data.frame(
  SPECIES    = c("PSEU_MEN", "POPU_TRE"),
  DBH        = c(17.4, 11.3),
  APPEARANCE = c(1, 4)
)

# --- Input validation ---

test_that("treeCalc aborts on invalid eval method", {
  expect_error(
    treeCalc(jk_data, eval = "bad_method", species = "SPECIES", dbh = "DBH"),
    regexp = "Not Available"
  )
})

test_that("treeCalc warns when crown_cond supplied with eval = 'jenkins'", {
  expect_message(
    suppressMessages(
      treeCalc(jk_data, eval = "jenkins", species = "SPECIES",
               dbh = "DBH", crown_cond = "APPEARANCE", output = "biomass", decay = FALSE)
    ),
    regexp = "crown_cond"
  )
})

test_that("treeCalc warns when rem_bark supplied with eval = 'jenkins'", {
  expect_message(
    suppressMessages(
      treeCalc(jk_data, eval = "jenkins", species = "SPECIES",
               dbh = "DBH", rem_bark = "APPEARANCE", output = "biomass", decay = FALSE)
    ),
    regexp = "rem_bark"
  )
})

test_that("treeCalc aborts for species not in JENKINS_GROUPS", {
  bad <- data.frame(SPECIES = "INVALID_SP", DBH = 10.0)
  expect_error(
    treeCalc(bad, eval = "jenkins", species = "SPECIES",
             dbh = "DBH", output = "biomass", decay = FALSE)
  )
})

test_that("treeCalc aborts when dbh is not numeric with jenkins", {
  bad <- jk_data
  bad$DBH <- as.character(bad$DBH)
  expect_error(
    suppressMessages(
      treeCalc(bad, eval = "jenkins", species = "SPECIES",
               dbh = "DBH", output = "biomass", decay = FALSE)
    ),
    regexp = "numeric"
  )
})

test_that("treeCalc warns on NAs in DBH with jenkins", {
  na_data <- jk_data
  na_data$DBH[1] <- NA
  expect_message(
    suppressMessages(
      treeCalc(na_data, eval = "jenkins", species = "SPECIES",
               dbh = "DBH", output = "biomass", decay = FALSE)
    ),
    regexp = "NAs"
  )
})

test_that("treeCalc aborts on invalid output with jenkins", {
  expect_error(
    suppressMessages(
      treeCalc(jk_data, eval = "jenkins", species = "SPECIES",
               dbh = "DBH", output = "bad_output", decay = FALSE)
    )
  )
})

test_that("treeCalc aborts when decay = TRUE and appearance not supplied with jenkins", {
  expect_error(
    suppressMessages(
      treeCalc(jk_data, eval = "jenkins", species = "SPECIES",
               dbh = "DBH", output = "biomass", decay = TRUE)
    )
  )
})

# --- Output correctness ---

test_that("treeCalc jenkins returns numeric vector with one value per row", {
  result <- suppressMessages(
    treeCalc(jk_data, eval = "jenkins", species = "SPECIES",
             dbh = "DBH", output = "biomass", decay = FALSE)
  )
  expect_type(result, "double")
  expect_length(result, nrow(jk_data))
})

test_that("treeCalc jenkins returns positive values", {
  result <- suppressMessages(
    treeCalc(jk_data, eval = "jenkins", species = "SPECIES",
             dbh = "DBH", output = "biomass", decay = FALSE)
  )
  expect_true(all(result > 0))
})

test_that("treeCalc jenkins carbon output is less than biomass output", {
  biomass <- suppressMessages(
    treeCalc(jk_data, eval = "jenkins", species = "SPECIES",
             dbh = "DBH", output = "biomass", decay = FALSE)
  )
  carbon <- suppressMessages(
    treeCalc(jk_data, eval = "jenkins", species = "SPECIES",
             dbh = "DBH", output = "carbon", decay = FALSE)
  )
  expect_true(all(carbon < biomass))
})

test_that("treeCalc jenkins returns correct known value for PSEU_MEN", {
  single <- data.frame(SPECIES = "PSEU_MEN", DBH = 10.0)
  result <- suppressMessages(
    treeCalc(single, eval = "jenkins", species = "SPECIES",
             dbh = "DBH", output = "biomass", decay = FALSE)
  )
  # PSEU_MEN -> Douglas-fir: BETA_0 = -2.2304, BETA_1 = 2.4435
  expected <- exp(-2.2304 + 2.4435 * log(10.0))
  expect_equal(result, expected, tolerance = 1e-6)
})

test_that("treeCalc jenkins and ung_1 return different values for same inputs", {
  jenkins_result <- suppressMessages(
    treeCalc(jk_data, eval = "jenkins", species = "SPECIES",
             dbh = "DBH", output = "biomass", decay = FALSE)
  )
  ung_result <- suppressMessages(
    treeCalc(jk_data, eval = "ung_1", species = "SPECIES",
             dbh = "DBH", crown_cond = "APPEARANCE", output = "biomass", decay = FALSE)
  )
  expect_false(identical(jenkins_result, ung_result))
})

test_that("treeCalc jenkins decay reduces values for decayed trees only", {
  no_decay <- suppressMessages(
    treeCalc(jk_data, eval = "jenkins", species = "SPECIES",
             dbh = "DBH", appearance = "APPEARANCE", output = "biomass", decay = FALSE)
  )
  with_decay <- suppressMessages(
    treeCalc(jk_data, eval = "jenkins", species = "SPECIES",
             dbh = "DBH", appearance = "APPEARANCE", output = "biomass", decay = TRUE)
  )
  expect_true(with_decay[2] < no_decay[2])   # APPEARANCE = 4, decay applies
  expect_equal(with_decay[1], no_decay[1])    # APPEARANCE = 1, no reduction
})
```

- [ ] **Step 2: Run tests — they must FAIL**

```powershell
cd "C:\Users\harristc\OneDrive - UBC\MTP\Packages\ForestBiomass"
Rscript -e "devtools::test_active_file('tests/testthat/test-treeCalc-jenkins.R')"
```

Expected: FAIL with errors about `"jenkins"` not being a valid eval option or `jenkinsCalculator` not found.

- [ ] **Step 3: Commit failing tests**

```powershell
cd "C:\Users\harristc\OneDrive - UBC\MTP\Packages\ForestBiomass"
git add tests/testthat/test-treeCalc-jenkins.R
git commit -m "test: add failing tests for Jenkins pathway in treeCalc()"
```

---

## Task 4: Implement jenkinsCalculator() and Update treeCalc()

**Files:**
- Create: `R/jenkinsCalculator.R`
- Modify: `R/treeCalc.R`

- [ ] **Step 1: Create `R/jenkinsCalculator.R`**

```r
#' Internal Function: Jenkins Calculator
#'
#' @param data User specified dataframe.
#' @param dbh Column within data where DBH is specified.
#' @param species Column within data where species is specified. NFI codes.
#' @param appearance Column within data where tree appearance is specified.
#' @param output Either "biomass" or "carbon".
#' @param decay Logical. Should the decay class reduction factor be applied?
#'
#' @returns A vector
#' @keywords internal

jenkinsCalculator <- function(data, dbh, species, appearance = NULL, output, decay) {

  carbon_mod <- carbonMod(output)
  result <- numeric(nrow(data))

  for (i in seq_len(nrow(data))) {
    species_spec <- data[[species]][i]

    group  <- ForestBiomass::JENKINS_GROUPS$SPECIES_GROUP[
                ForestBiomass::JENKINS_GROUPS$SPECIES == species_spec]
    beta_0 <- ForestBiomass::JENKINS$BETA_0[ForestBiomass::JENKINS$SPECIES_GROUP == group]
    beta_1 <- ForestBiomass::JENKINS$BETA_1[ForestBiomass::JENKINS$SPECIES_GROUP == group]

    bm <- exp(beta_0 + beta_1 * log(data[[dbh]][i]))

    decay_mod <- if (decay) ForestBiomass::DCRF(data, appearance, species = species_spec, i) else 1

    result[i] <- bm * decay_mod * carbon_mod
  }

  return(result)
}
```

- [ ] **Step 2: Overwrite `R/treeCalc.R`**

```r
#' Tree Biomass Calculation
#'
#' @description Calculates total above-ground tree biomass or carbon. Two methodologies
#' are available: (1) summing wood, branch, foliage, and bark components using allometric
#' equations from Ung et al., 2008 or Lambert et al., 2005; or (2) direct total
#' above-ground biomass via Jenkins et al., 2003 national-scale equations.
#' A species-specific decay class reduction factor (Harmon et al., 2011) can be applied.
#'
#' @param data User specified dataframe.
#' @param eval Which equation set to use. Default is "ung_2". Options are:
#' "ung_1", "ung_2", "lambert_1", "lambert_2" (component-sum pathway), or
#' "jenkins" (Jenkins et al., 2003 direct total biomass).
#' @param dbh Column within data where Diameter at Breast Height (dbh) is specified.
#' @param height Optional. Required for "lambert_2" or "ung_2".
#' @param species Column within data where species is specified. NFI codes for species.
#' @param appearance Optional. Required when decay = TRUE.
#' @param crown_cond Column within data where crown condition is specified. Required
#' for "ung_1", "ung_2", "lambert_1", "lambert_2". Not used with "jenkins".
#' @param rem_bark Optional. Column within data where remaining bark percentage (0-100)
#' is specified. Not used with "jenkins".
#' @param output Either "biomass" (default, kg) or "carbon" (Mg/ha).
#' @param decay Logical with default = TRUE. Should the decay class reduction factor be applied?
#'
#' @returns A vector.
#' @export
#'
#' @examples treeCalc(data = trees_data, eval = "ung_2", species = "LGTREE_NFI",
#' dbh = "DBH", height = "HEIGHT", appearance = "APPEARANCE",
#' crown_cond = "CROWN_COND", output = "biomass", decay = TRUE)

treeCalc <- function(data, eval = "ung_2",
                     dbh, height = NULL, species, appearance = NULL,
                     crown_cond = NULL, rem_bark = NULL,
                     output = "biomass", decay = TRUE) {

  if (!eval %in% c("ung_1", "ung_2", "lambert_1", "lambert_2", "jenkins"))
    rlang::abort("Specified Method Not Available")

  if (eval == "jenkins") {
    if (!is.null(crown_cond))
      message("'crown_cond' is not used with eval = 'jenkins' and will be ignored.")
    if (!is.null(rem_bark))
      message("'rem_bark' is not used with eval = 'jenkins' and will be ignored.")

    if (!all(data[[species]] %in% ForestBiomass::JENKINS_GROUPS$SPECIES))
      rlang::abort("One or more species not found in JENKINS_GROUPS.")

    if (!is.numeric(data[[dbh]]))
      stop("'dbh' must be a numeric vector.", call. = FALSE)

    if (any(is.na(data[[dbh]])))
      message(paste("Warning: NAs detected in", dbh))

    if (!output %in% c("biomass", "carbon"))
      rlang::abort("'output' must be \"biomass\" or \"carbon\".")

    if (decay && is.null(appearance))
      stop("'appearance' is required when decay = TRUE.", call. = FALSE)

    message(paste("Output:", output, if (output == "biomass") "(kg)" else "(Mg/ha)"))
    if (decay) message("Species specified decay reduction factor applied (Harmon et al., 2011)")

    return(jenkinsCalculator(data, dbh = dbh, species = species,
                              appearance = appearance, output = output, decay = decay))
  }

  validateSpecies(data[[species]], eval)

  if (!is.numeric(data[[dbh]]))
    stop("'dbh' must be a numeric vector.", call. = FALSE)

  if (any(is.na(data[[dbh]])))
    message(paste("Warning: NAs detected in", dbh))

  if (eval %in% c("lambert_2", "ung_2")) {
    if (is.null(height))
      stop(paste0("'height' is required for ", eval, "."), call. = FALSE)
    if (any(is.na(data[[height]])))
      message(paste("Warning: NAs detected in", height))
  }

  if (!output %in% c("biomass", "carbon"))
    rlang::abort("'output' must be \"biomass\" or \"carbon\".")

  if (decay && is.null(appearance))
    stop("'appearance' is required when decay = TRUE.", call. = FALSE)

  if (is.null(crown_cond))
    stop("'crown_cond' is required when eval is not 'jenkins'.", call. = FALSE)

  message(paste("Output:", output, if (output == "biomass") "(kg)" else "(Mg/ha)"))
  if (decay) message("Species specified decay reduction factor applied (Harmon et al., 2011)")

  wood    <- suppressMessages(woodCalc(data, eval = eval, dbh = dbh, height = height,
                                       species = species, appearance = appearance,
                                       output = output, decay = decay))
  bark    <- suppressMessages(barkCalc(data, eval = eval, dbh = dbh, height = height,
                                       species = species, appearance = appearance,
                                       rem_bark = rem_bark, output = output, decay = decay))
  branch  <- suppressMessages(branchCalc(data, eval = eval, dbh = dbh, height = height,
                                         species = species, appearance = appearance,
                                         crown_cond = crown_cond, output = output, decay = decay))
  foliage <- suppressMessages(foliageCalc(data, eval = eval, dbh = dbh, height = height,
                                          species = species, appearance = appearance,
                                          crown_cond = crown_cond, output = output, decay = decay))

  wood + bark + branch + foliage
}
```

- [ ] **Step 3: Regenerate documentation**

In RStudio console:
```r
devtools::document()
```

- [ ] **Step 4: Run Jenkins tests — they must now PASS**

```powershell
cd "C:\Users\harristc\OneDrive - UBC\MTP\Packages\ForestBiomass"
Rscript -e "devtools::test_active_file('tests/testthat/test-treeCalc-jenkins.R')"
```

Expected: all tests PASS.

- [ ] **Step 5: Run full test suite — all must pass**

```powershell
cd "C:\Users\harristc\OneDrive - UBC\MTP\Packages\ForestBiomass"
Rscript -e "devtools::test()"
```

Expected: all tests PASS with no failures or warnings.

- [ ] **Step 6: Commit**

```powershell
cd "C:\Users\harristc\OneDrive - UBC\MTP\Packages\ForestBiomass"
git add R/jenkinsCalculator.R R/treeCalc.R
git commit -m "feat: add Jenkins et al. 2003 pathway to treeCalc() via eval = 'jenkins'"
```

---

## Task 5: Update CLAUDE.md

**Files:**
- Modify: `CLAUDE.md`

- [ ] **Step 1: Update the implementation status table**

Replace the Current Implementation Status table with:

```markdown
## Current Implementation Status

| Component | User function       | Status   |
|-----------|---------------------|----------|
| Wood      | `woodCalc()`        | Complete |
| Branches  | `branchCalc()`      | Complete |
| Foliage   | `foliageCalc()`     | Complete |
| Bark      | `barkCalc()`        | Complete |
| Total AGB | `treeCalc()`        | Complete (Ung, Lambert, Jenkins) |
```

- [ ] **Step 2: Commit**

```powershell
cd "C:\Users\harristc\OneDrive - UBC\MTP\Packages\ForestBiomass"
git add CLAUDE.md
git commit -m "docs: update CLAUDE.md to reflect Jenkins treeCalc() implementation"
```
