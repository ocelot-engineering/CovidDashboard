#
# Test outbreak rating
#


# Set up ------------------------------------------------------------------

daily_cases <- get_test_data("daily_cases")
population <- get_test_data("population")
daily_cases_sel <- daily_cases %>% dplyr::select(DATE_REPORTED, COUNTRY_CODE, NEW_CASES)
population_sel <- population %>% dplyr::select(DATE_REPORTED, COUNTRY_CODE, COUNTRY, POPULATION)
daily_cases_w_pop <- dplyr::left_join(daily_cases_sel, population_sel, by = c("DATE_REPORTED", "COUNTRY_CODE"))

outbreak_ratings = generate_daily_outbreak_ratings(daily_cases_w_pop)

testthat::test_that("outbreak ratings has same rows as daily cases", {
    testthat::expect_equal(nrow(outbreak_ratings), nrow(daily_cases))
})

testthat::test_that("outbreak ratings are different per row", {
    testthat::expect_length(unique(outbreak_ratings$OUTBREAK_RATING), 4L)
    testthat::expect_length(unique(outbreak_ratings$OUTBREAK_DESC), 2L)
})

testthat::test_that("outbreak ratings has includes outbreak column names", {
    col_names <- c("OUTBREAK_RATING", "OUTBREAK_DESC")
    testthat::expect_true(all(col_names %in% colnames(outbreak_ratings)))
})


# outbreak_rating ---------------------------------------------------------

testthat::test_that("outbreak_rating correcty calculates new cases per 100k population", {
    testthat::expect_equal(calculate_outbreak_rating(new_cases = 25, population = 100000), 25)
})

testthat::test_that("outbreak_rating has max and min limits", {
    testthat::expect_equal(calculate_outbreak_rating(new_cases = 25, population = 1), 100)
    testthat::expect_equal(calculate_outbreak_rating(new_cases = -1, population = 1), 0)
})


# describe_outbreak -------------------------------------------------------

testthat::test_that("describe_outbreak makes correct descriptions", {
    desc <- c(
        "No new cases"
      , "Low"
      , "Medium"
      , "High"
      , "Extreme"
      , NA_character_
    )
    
    testthat::expect_equal(describe_outbreak(0), desc[1])
    
    testthat::expect_equal(describe_outbreak(1), desc[2])
    testthat::expect_equal(describe_outbreak(2), desc[2])
    testthat::expect_equal(describe_outbreak(9), desc[2])
    
    testthat::expect_equal(describe_outbreak(10), desc[3])
    testthat::expect_equal(describe_outbreak(19), desc[3])
    testthat::expect_equal(describe_outbreak(19.9), desc[3])
    
    testthat::expect_equal(describe_outbreak(20), desc[4])
    testthat::expect_equal(describe_outbreak(29), desc[4])
    
    testthat::expect_equal(describe_outbreak(30), desc[5])
    testthat::expect_equal(describe_outbreak(31), desc[5])
    testthat::expect_equal(describe_outbreak(100), desc[5])
    testthat::expect_equal(describe_outbreak(1000), desc[5])
    
    testthat::expect_equal(describe_outbreak(-1), NA_character_)
    testthat::expect_equal(describe_outbreak(Inf), NA_character_)
})

testthat::test_that("describe_outbreak can handle vector", {
    testthat::expect_vector(describe_outbreak(c(0, 1, 29, 100, -1)), size = 5L)
})
