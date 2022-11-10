
daily_cases <- get_test_data(name = "daily_cases")


testthat::test_that("calc_new_and_total correctly returns new and total deaths and percentage increase", {
    deaths <- calc_new_and_total(  daily_cases = daily_cases
                                 , new_col = "NEW_DEATHS"
                                 , total_col = "CUMULATIVE_DEATHS")
    
    testthat::expect_equal(deaths$new_cases, 29)
    testthat::expect_equal(deaths$total_cases, 5279)
    testthat::expect_equal(round(deaths$perc_inc, 3), 1.231)
})


testthat::test_that("calc_new_and_total correctly returns new and total cases and percentage increase", {
    cases <- calc_new_and_total(  daily_cases = daily_cases
                                 , new_col = "NEW_CASES"
                                 , total_col = "CUMULATIVE_CASES")
    
    testthat::expect_equal(cases$new_cases, 211)
    testthat::expect_equal(cases$total_cases, 116189)
    testthat::expect_equal(round(cases$perc_inc, 3), 0.066)
})


testthat::test_that("calc_cases correctly returns new and total cases and percentage increase", {
    cases <- calc_cases(daily_cases = daily_cases)
    
    testthat::expect_equal(cases$new_cases, 211)
    testthat::expect_equal(cases$total_cases, 116189)
    testthat::expect_equal(round(cases$perc_inc, 3), 0.066)
})


testthat::test_that("calc_deaths correctly returns new and total deaths and percentage increase", {
    deaths <- calc_deaths(daily_cases = daily_cases)
    
    testthat::expect_equal(deaths$new_cases, 29)
    testthat::expect_equal(deaths$total_cases, 5279)
    testthat::expect_equal(round(deaths$perc_inc, 3), 1.231)
})
