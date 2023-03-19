#
# ETL functions
#

run_etl_pipline <- function() {
    build_daily_cases_dataset()
    build_vaccination_dataset()
    build_population_dataset()
}