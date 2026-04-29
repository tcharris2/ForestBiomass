library(testthat)

jk_data <- data.frame(
  SPECIES    = c("PSEU_MEN", "POPU_TRE"),
  DBH        = c(17.4, 11.3),
  APPEARANCE = c(1, 4)
)

# --- Input validation ---

test_that("treeCalc warns when crown_cond supplied with eval = 'jenkins'", {
  expect_message(
    treeCalc(jk_data, eval = "jenkins", species = "SPECIES",
             dbh = "DBH", crown_cond = "APPEARANCE", output = "biomass", decay = FALSE),
    regexp = "crown_cond"
  )
})

test_that("treeCalc warns when rem_bark supplied with eval = 'jenkins'", {
  expect_message(
    treeCalc(jk_data, eval = "jenkins", species = "SPECIES",
             dbh = "DBH", rem_bark = "APPEARANCE", output = "biomass", decay = FALSE),
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
