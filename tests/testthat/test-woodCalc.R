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
    woodCalc(na_data, eval = "ung_eqn_1", species = "SPECIES",
             dbh = "DBH", output = "biomass", decay = FALSE),
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
