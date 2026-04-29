library(testthat)

# PICE_MAR = softwood, POPU_TRE = hardwood
root_data <- data.frame(
  SPECIES = c("PICE_MAR", "POPU_TRE"),
  AGB     = c(10.0, 10.0)
)

# --- Input validation ---

test_that("rootCalc aborts for species not in SPECIES_CLASS", {
  bad <- data.frame(SPECIES = "INVALID", AGB = 10.0)
  expect_error(rootCalc(bad, biomass = "AGB", species = "SPECIES"))
})

test_that("rootCalc stops for non-numeric biomass column", {
  bad <- data.frame(SPECIES = "PICE_MAR", AGB = "ten")
  expect_error(rootCalc(bad, biomass = "AGB", species = "SPECIES"))
})

test_that("rootCalc warns on NAs in biomass column", {
  na_data <- data.frame(SPECIES = "PICE_MAR", AGB = NA_real_)
  expect_message(
    suppressWarnings(rootCalc(na_data, biomass = "AGB", species = "SPECIES")),
    regexp = "NA"
  )
})

test_that("rootCalc aborts on invalid root_type", {
  expect_error(
    suppressMessages(rootCalc(root_data, biomass = "AGB", species = "SPECIES",
                              root_type = "stem"))
  )
})

test_that("rootCalc aborts on invalid output", {
  expect_error(
    suppressMessages(rootCalc(root_data, biomass = "AGB", species = "SPECIES",
                              output = "biomass"))
  )
})

# --- Output correctness ---

test_that("rootCalc returns a numeric vector with one value per row", {
  result <- suppressMessages(
    rootCalc(root_data, biomass = "AGB", species = "SPECIES")
  )
  expect_type(result, "double")
  expect_length(result, nrow(root_data))
})

test_that("rootCalc returns non-negative values", {
  result <- suppressMessages(
    rootCalc(root_data, biomass = "AGB", species = "SPECIES")
  )
  expect_true(all(result >= 0))
})

test_that("rootCalc total equals fine plus coarse", {
  total <- suppressMessages(
    rootCalc(root_data, biomass = "AGB", species = "SPECIES", root_type = "total")
  )
  fine <- suppressMessages(
    rootCalc(root_data, biomass = "AGB", species = "SPECIES", root_type = "fine")
  )
  coarse <- suppressMessages(
    rootCalc(root_data, biomass = "AGB", species = "SPECIES", root_type = "coarse")
  )
  expect_equal(fine + coarse, total, tolerance = 1e-10)
})

test_that("rootCalc carbon output is less than biomass output", {
  biomass_out <- suppressMessages(
    rootCalc(root_data, biomass = "AGB", species = "SPECIES", output = "biomass Mg/ha")
  )
  carbon_out <- suppressMessages(
    rootCalc(root_data, biomass = "AGB", species = "SPECIES", output = "carbon Mg/ha")
  )
  expect_true(all(carbon_out < biomass_out))
})

test_that("rootCalc softwood known value: RB = 0.222 * AB", {
  sw <- data.frame(SPECIES = "PICE_MAR", AGB = 10.0)
  result <- suppressMessages(
    rootCalc(sw, biomass = "AGB", species = "SPECIES", output = "biomass Mg/ha")
  )
  expect_equal(result, 0.222 * 10.0, tolerance = 1e-10)
})

test_that("rootCalc hardwood known value: RB = 1.576 * AB^0.615", {
  hw <- data.frame(SPECIES = "POPU_TRE", AGB = 10.0)
  result <- suppressMessages(
    rootCalc(hw, biomass = "AGB", species = "SPECIES", output = "biomass Mg/ha")
  )
  expect_equal(result, 1.576 * 10.0 ^ 0.615, tolerance = 1e-10)
})

# --- root_type behaviour ---

test_that("rootCalc fine is smaller than total", {
  total <- suppressMessages(
    rootCalc(root_data, biomass = "AGB", species = "SPECIES", root_type = "total")
  )
  fine <- suppressMessages(
    rootCalc(root_data, biomass = "AGB", species = "SPECIES", root_type = "fine")
  )
  expect_true(all(fine < total))
})

test_that("rootCalc coarse is smaller than total", {
  total <- suppressMessages(
    rootCalc(root_data, biomass = "AGB", species = "SPECIES", root_type = "total")
  )
  coarse <- suppressMessages(
    rootCalc(root_data, biomass = "AGB", species = "SPECIES", root_type = "coarse")
  )
  expect_true(all(coarse < total))
})

test_that("rootCalc softwood and hardwood return different values for same AGB", {
  result <- suppressMessages(
    rootCalc(root_data, biomass = "AGB", species = "SPECIES")
  )
  expect_false(result[1] == result[2])
})
