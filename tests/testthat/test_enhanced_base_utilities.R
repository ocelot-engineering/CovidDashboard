#
# Test enhanced base utilities
#

# make_formula ------------------------------------------------------------

testthat::test_that("make_formula outputs a formula object", {
    testthat::expect_s3_class(make_formula(x = "DATE", prefix = "~"), class = "formula")
})

testthat::test_that("make_formula works for prefix and suffix", {
    testthat::expect_equal(make_formula(x = "DATE", prefix = "~"), expected = ~DATE)
    testthat::expect_equal(make_formula(x = "DATE~X", prefix = "", suffix = ""), expected = DATE ~ X)
    testthat::expect_equal(make_formula(x = "DATE~X", prefix = "", suffix = "YZ"), expected = DATE ~ XYZ)
})
