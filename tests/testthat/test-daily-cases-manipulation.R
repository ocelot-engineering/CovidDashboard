
daily_cases <- get_test_data(name = "daily_cases")


testthat::test_that("get_latest_info_by_country gets latest rows (no lag)", {
    latest_rows_by_country <- get_latest_info_by_country(daily_cases, lag = 0)
    
    au_latest <- latest_rows_by_country %>% filter(COUNTRY_CODE == "AU") %>% pull(DATE_REPORTED)
    bz_latest <- latest_rows_by_country %>% filter(COUNTRY_CODE == "BZ") %>% pull(DATE_REPORTED)
    cn_latest <- latest_rows_by_country %>% filter(COUNTRY_CODE == "CN") %>% pull(DATE_REPORTED)
    
    testthat::expect_equal(au_latest, as.Date("2020-08-27"))
    testthat::expect_equal(bz_latest, as.Date("2020-08-26"))
    testthat::expect_equal(cn_latest, as.Date("2020-08-27"))
})


testthat::test_that("get_latest_info_by_country gets latest rows allows for lags", {
    # lag 1
    latest_rows_by_country <- get_latest_info_by_country(daily_cases, lag = 1)
    
    au_latest <- latest_rows_by_country %>% filter(COUNTRY_CODE == "AU") %>% pull(DATE_REPORTED)
    bz_latest <- latest_rows_by_country %>% filter(COUNTRY_CODE == "BZ") %>% pull(DATE_REPORTED)
    cn_latest <- latest_rows_by_country %>% filter(COUNTRY_CODE == "CN") %>% pull(DATE_REPORTED)
    
    testthat::expect_equal(au_latest, as.Date("2020-08-26"))
    testthat::expect_equal(bz_latest, as.Date("2020-08-26"))
    testthat::expect_equal(cn_latest, as.Date("2020-08-26"))
    
    
    # lag 2
    latest_rows_by_country <- get_latest_info_by_country(daily_cases, lag = 2)
    
    au_latest <- latest_rows_by_country %>% filter(COUNTRY_CODE == "AU") %>% pull(DATE_REPORTED)
    bz_latest <- latest_rows_by_country %>% filter(COUNTRY_CODE == "BZ") %>% pull(DATE_REPORTED)
    cn_latest <- latest_rows_by_country %>% filter(COUNTRY_CODE == "CN") %>% pull(DATE_REPORTED)
    
    testthat::expect_equal(au_latest, as.Date("2020-08-25"))
    testthat::expect_equal(bz_latest, as.Date("2020-08-25"))
    testthat::expect_equal(cn_latest, as.Date("2020-08-25"))
    
})


testthat::test_that("get_latest_info_by_country gets latest rows allows for negative lags", {
    latest_rows_by_country <- get_latest_info_by_country(daily_cases, lag = -1)
    
    au_latest <- latest_rows_by_country %>% filter(COUNTRY_CODE == "AU") %>% pull(DATE_REPORTED)
    bz_latest <- latest_rows_by_country %>% filter(COUNTRY_CODE == "BZ") %>% pull(DATE_REPORTED)
    cn_latest <- latest_rows_by_country %>% filter(COUNTRY_CODE == "CN") %>% pull(DATE_REPORTED)
    
    testthat::expect_equal(au_latest, as.Date("2020-08-26"))
    testthat::expect_equal(bz_latest, as.Date("2020-08-26"))
    testthat::expect_equal(cn_latest, as.Date("2020-08-26"))
})
