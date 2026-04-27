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
