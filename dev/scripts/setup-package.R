#
# Initalises the package
#

stop("Do not source script.")

devtools::load_all()

usethis::create_package(path = "CovidDashboard", rstudio = TRUE)
usethis::use_testthat()
usethis::use_pipe(export = TRUE)
usethis::use_gpl_license(version = 3, include_future = TRUE)
usethis::use_readme_rmd()
usethis::use_lifecycle_badge("experimental")


# Package dependencies ----------------------------------------------------

usethis::use_package("dplyr")
usethis::use_package("devtools", type = "Suggests")
usethis::use_package("rlang")
usethis::use_package("checkmate")
usethis::use_package("forecast")

devtools::install_deps(upgrade = "never")
