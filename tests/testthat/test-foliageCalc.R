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
    foliageCalc(bad, eval = "ung_1", species = "SPECIES",
                dbh = "DBH", crown_cond = "CROWN_COND")
  )
})

test_that("foliageCalc aborts when height-based equation is used without height", {
  expect_error(
    foliageCalc(fo_data, eval = "ung_2", species = "SPECIES", dbh = "DBH",
                crown_cond = "CROWN_COND", output = "biomass", decay = FALSE),
    regexp = "height"
  )
})

test_that("foliageCalc aborts when decay = TRUE and appearance is not provided", {
  expect_error(
    suppressMessages(
      foliageCalc(fo_data, eval = "ung_1", species = "SPECIES", dbh = "DBH",
                  crown_cond = "CROWN_COND", output = "biomass", decay = TRUE)
    ),
    regexp = "appearance"
  )
})

test_that("foliageCalc aborts on invalid output value", {
  expect_error(
    suppressMessages(
      foliageCalc(fo_data, eval = "ung_1", species = "SPECIES", dbh = "DBH",
                  crown_cond = "CROWN_COND", output = "invalid", decay = FALSE)
    ),
    regexp = "output"
  )
})

test_that("foliageCalc returns numeric vector with one value per row", {
  result <- suppressMessages(
    foliageCalc(fo_data, eval = "ung_1", species = "SPECIES",
                dbh = "DBH", crown_cond = "CROWN_COND",
                appearance = "APPEARANCE", output = "biomass", decay = FALSE)
  )
  expect_type(result, "double")
  expect_length(result, nrow(fo_data))
})

test_that("foliageCalc returns non-negative values", {
  result <- suppressMessages(
    foliageCalc(fo_data, eval = "ung_1", species = "SPECIES",
                dbh = "DBH", crown_cond = "CROWN_COND",
                appearance = "APPEARANCE", output = "biomass", decay = FALSE)
  )
  expect_true(all(result >= 0))
})

test_that("foliageCalc carbon output is less than biomass output", {
  biomass <- suppressMessages(
    foliageCalc(fo_data, eval = "ung_1", species = "SPECIES",
                dbh = "DBH", crown_cond = "CROWN_COND",
                appearance = "APPEARANCE", output = "biomass", decay = FALSE)
  )
  carbon <- suppressMessages(
    foliageCalc(fo_data, eval = "ung_1", species = "SPECIES",
                dbh = "DBH", crown_cond = "CROWN_COND",
                appearance = "APPEARANCE", output = "carbon", decay = FALSE)
  )
  expect_true(all(carbon < biomass))
})

test_that("foliageCalc returns 0 for snag (appearance > 5)", {
  snag <- data.frame(SPECIES = "PSEU_MEN", DBH = 17.4, HEIGHT = 10.9,
                     APPEARANCE = 6, CROWN_COND = 1)
  result <- suppressMessages(
    foliageCalc(snag, eval = "ung_1", species = "SPECIES",
                dbh = "DBH", crown_cond = "CROWN_COND",
                appearance = "APPEARANCE", output = "biomass", decay = FALSE)
  )
  expect_equal(result, 0)
})

test_that("foliageCalc returns correct known value for PSEU_MEN ung_eqn_1", {
  single <- data.frame(SPECIES = "PSEU_MEN", DBH = 10.0, HEIGHT = 10.0,
                       APPEARANCE = 1, CROWN_COND = 1)
  result <- suppressMessages(
    foliageCalc(single, eval = "ung_1", species = "SPECIES",
                dbh = "DBH", crown_cond = "CROWN_COND",
                appearance = "APPEARANCE", output = "biomass", decay = FALSE)
  )
  # From ung1data.R: PSEU_MEN FOLIAGE beta1=0.1233, beta2=1.6636
  # condition_mod=1 (CROWN_COND=1), appearance_mod=1 (APPEARANCE=1)
  expected <- 0.1233 * 10^1.6636
  expect_equal(result, expected, tolerance = 1e-6)
})
