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

test_that("betaVal returns numeric values for valid species and component", {
  result <- betaVal(method = ForestBiomass::UNG_1, species = "PSEU_MEN", component = "WOOD")
  expect_true(length(result) >= 2)
  expect_type(result, "double")
})

test_that("betaVal returns correct known values for PSEU_MEN WOOD in UNG_1", {
  result <- betaVal(method = ForestBiomass::UNG_1, species = "PSEU_MEN", component = "WOOD")
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
