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
    barkCalc(bad, eval = "ung_1", species = "SPECIES", dbh = "DBH")
  )
})

test_that("barkCalc aborts when height-based equation is used without height", {
  expect_error(
    barkCalc(bk_data, eval = "ung_2", species = "SPECIES", dbh = "DBH",
             output = "biomass", decay = FALSE),
    regexp = "height"
  )
})

test_that("barkCalc aborts when decay = TRUE and appearance is not provided", {
  expect_error(
    suppressMessages(
      barkCalc(bk_data, eval = "ung_1", species = "SPECIES", dbh = "DBH",
               output = "biomass", decay = TRUE)
    ),
    regexp = "appearance"
  )
})

test_that("barkCalc aborts on invalid output value", {
  expect_error(
    suppressMessages(
      barkCalc(bk_data, eval = "ung_1", species = "SPECIES", dbh = "DBH",
               output = "invalid", decay = FALSE)
    ),
    regexp = "output"
  )
})

test_that("barkCalc returns numeric vector with one value per row", {
  result <- suppressMessages(
    barkCalc(bk_data, eval = "ung_1", species = "SPECIES",
             dbh = "DBH", rem_bark = "REM_BARK", output = "biomass", decay = FALSE)
  )
  expect_type(result, "double")
  expect_length(result, nrow(bk_data))
})

test_that("barkCalc returns non-negative values", {
  result <- suppressMessages(
    barkCalc(bk_data, eval = "ung_1", species = "SPECIES",
             dbh = "DBH", rem_bark = "REM_BARK", output = "biomass", decay = FALSE)
  )
  expect_true(all(result >= 0))
})

test_that("barkCalc carbon output is less than biomass output", {
  biomass <- suppressMessages(
    barkCalc(bk_data, eval = "ung_1", species = "SPECIES",
             dbh = "DBH", rem_bark = "REM_BARK", output = "biomass", decay = FALSE)
  )
  carbon <- suppressMessages(
    barkCalc(bk_data, eval = "ung_1", species = "SPECIES",
             dbh = "DBH", rem_bark = "REM_BARK", output = "carbon", decay = FALSE)
  )
  expect_true(all(carbon < biomass))
})

test_that("barkCalc with rem_bark = 50 returns half the value of rem_bark = 100", {
  full  <- data.frame(SPECIES = "PSEU_MEN", DBH = 10.0, REM_BARK = 100, APPEARANCE = 1)
  half  <- data.frame(SPECIES = "PSEU_MEN", DBH = 10.0, REM_BARK = 50,  APPEARANCE = 1)
  r_full <- suppressMessages(
    barkCalc(full, eval = "ung_1", species = "SPECIES",
             dbh = "DBH", rem_bark = "REM_BARK", output = "biomass", decay = FALSE)
  )
  r_half <- suppressMessages(
    barkCalc(half, eval = "ung_1", species = "SPECIES",
             dbh = "DBH", rem_bark = "REM_BARK", output = "biomass", decay = FALSE)
  )
  expect_equal(r_half, r_full * 0.5, tolerance = 1e-6)
})

test_that("barkCalc returns correct known value for PSEU_MEN ung_1 full bark", {
  single <- data.frame(SPECIES = "PSEU_MEN", DBH = 10.0, REM_BARK = 100, APPEARANCE = 1)
  result <- suppressMessages(
    barkCalc(single, eval = "ung_1", species = "SPECIES",
             dbh = "DBH", rem_bark = "REM_BARK", output = "biomass", decay = FALSE)
  )
  # From ung1data.R: PSEU_MEN BARK beta1=0.0069, beta2=2.5462
  # rem_bark modifier = 100/100 = 1
  expected <- 0.0069 * 10^2.5462
  expect_equal(result, expected, tolerance = 1e-6)
})
