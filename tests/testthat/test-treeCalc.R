library(testthat)

tr_data <- data.frame(
  SPECIES    = c("PSEU_MEN", "TSUG_HET"),
  DBH        = c(17.4, 11.3),
  HEIGHT     = c(10.9, 9.8),
  APPEARANCE = c(1, 4),
  CROWN_COND = c(1, 3)
)

# --- Input validation ---

test_that("treeCalc aborts on invalid eval method", {
  expect_error(
    treeCalc(tr_data, eval = "bad_method", species = "SPECIES",
             dbh = "DBH", crown_cond = "CROWN_COND"),
    regexp = "Not Available"
  )
})

test_that("treeCalc aborts when crown_cond is not supplied for component-sum pathway", {
  expect_error(
    suppressMessages(
      treeCalc(tr_data, eval = "ung_1", species = "SPECIES",
               dbh = "DBH", output = "biomass", decay = FALSE)
    ),
    regexp = "crown_cond"
  )
})

test_that("treeCalc aborts when height-based equation is used without height", {
  expect_error(
    treeCalc(tr_data, eval = "ung_2", species = "SPECIES", dbh = "DBH",
             crown_cond = "CROWN_COND", output = "biomass", decay = FALSE),
    regexp = "height"
  )
})

test_that("treeCalc aborts when decay = TRUE and appearance is not provided", {
  expect_error(
    suppressMessages(
      treeCalc(tr_data, eval = "ung_1", species = "SPECIES", dbh = "DBH",
               crown_cond = "CROWN_COND", output = "biomass", decay = TRUE)
    ),
    regexp = "appearance"
  )
})

test_that("treeCalc aborts on invalid output value", {
  expect_error(
    suppressMessages(
      treeCalc(tr_data, eval = "ung_1", species = "SPECIES", dbh = "DBH",
               crown_cond = "CROWN_COND", output = "invalid", decay = FALSE)
    ),
    regexp = "output"
  )
})

test_that("treeCalc aborts when dbh is not numeric", {
  bad <- tr_data
  bad$DBH <- as.character(bad$DBH)
  expect_error(
    suppressMessages(
      treeCalc(bad, eval = "ung_1", species = "SPECIES",
               dbh = "DBH", crown_cond = "CROWN_COND")
    ),
    regexp = "numeric"
  )
})

# --- Output correctness ---

test_that("treeCalc returns a numeric vector with one value per row", {
  result <- suppressMessages(
    treeCalc(tr_data, eval = "ung_1", species = "SPECIES",
             dbh = "DBH", crown_cond = "CROWN_COND", output = "biomass", decay = FALSE)
  )
  expect_type(result, "double")
  expect_length(result, nrow(tr_data))
})

test_that("treeCalc result equals sum of all four components", {
  wood    <- suppressMessages(woodCalc(tr_data, eval = "ung_1", species = "SPECIES",
                                       dbh = "DBH", output = "biomass", decay = FALSE))
  bark    <- suppressMessages(barkCalc(tr_data, eval = "ung_1", species = "SPECIES",
                                       dbh = "DBH", output = "biomass", decay = FALSE))
  branch  <- suppressMessages(branchCalc(tr_data, eval = "ung_1", species = "SPECIES",
                                         dbh = "DBH", crown_cond = "CROWN_COND",
                                         output = "biomass", decay = FALSE))
  foliage <- suppressMessages(foliageCalc(tr_data, eval = "ung_1", species = "SPECIES",
                                          dbh = "DBH", crown_cond = "CROWN_COND",
                                          output = "biomass", decay = FALSE))
  result <- suppressMessages(
    treeCalc(tr_data, eval = "ung_1", species = "SPECIES",
             dbh = "DBH", crown_cond = "CROWN_COND", output = "biomass", decay = FALSE)
  )
  expect_equal(result, wood + bark + branch + foliage)
})

test_that("treeCalc carbon output is less than biomass output", {
  biomass <- suppressMessages(
    treeCalc(tr_data, eval = "ung_1", species = "SPECIES",
             dbh = "DBH", crown_cond = "CROWN_COND", output = "biomass", decay = FALSE)
  )
  carbon <- suppressMessages(
    treeCalc(tr_data, eval = "ung_1", species = "SPECIES",
             dbh = "DBH", crown_cond = "CROWN_COND", output = "carbon", decay = FALSE)
  )
  expect_true(all(carbon < biomass))
})

test_that("treeCalc decay reduces biomass for decayed trees", {
  no_decay <- suppressMessages(
    treeCalc(tr_data, eval = "ung_1", species = "SPECIES",
             dbh = "DBH", appearance = "APPEARANCE", crown_cond = "CROWN_COND",
             output = "biomass", decay = FALSE)
  )
  with_decay <- suppressMessages(
    treeCalc(tr_data, eval = "ung_1", species = "SPECIES",
             dbh = "DBH", appearance = "APPEARANCE", crown_cond = "CROWN_COND",
             output = "biomass", decay = TRUE)
  )
  expect_true(with_decay[2] < no_decay[2])  # APPEARANCE=4, decay applies
  expect_equal(with_decay[1], no_decay[1])  # APPEARANCE=1, no reduction
})

test_that("treeCalc ung_2 gives different result from ung_1", {
  eqn1 <- suppressMessages(
    treeCalc(tr_data, eval = "ung_1", species = "SPECIES",
             dbh = "DBH", crown_cond = "CROWN_COND", output = "biomass", decay = FALSE)
  )
  eqn2 <- suppressMessages(
    treeCalc(tr_data, eval = "ung_2", species = "SPECIES",
             dbh = "DBH", height = "HEIGHT", crown_cond = "CROWN_COND",
             output = "biomass", decay = FALSE)
  )
  expect_false(identical(eqn1, eqn2))
})
