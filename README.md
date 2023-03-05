
<!-- README.md is generated from README.Rmd. Please edit that file -->

# COVID-19 Dashboard

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

![Screenshot of dashboard](inst/assets/images/snapshot-sm.png)

The purpose of this application is to provide users with an up-to-date
view of the worldwide Covid-19 situation. It provides useful metrics to
assist in decision making for those who reside or intend to visit
countries impacted by Covid-19.

## Data

The data used in this dashboard is sourced from the [World Health
Organisation (WHO)](https://covid19.who.int/data).

A data pipeline will run daily where it downloads the data to the local
repo and saves and an RDS file, this is to keep any tibble metadata.
Given the data is very small, there is no need to worry about memory,
storage, input or output. If datasets were to grow to a very large size,
then the [fst package](https://www.fstpackage.org/) would be used for
reading and writing and resulting files will be coerced to tibble (which
is a very fast operation given the underlying data doesn’t change, more
meta data is just added.)

Data is saved in the `data/` directory, which is gitignored. Details of
source links and schemas are located in `config/data_source_config.R`.
Each data source has information for `url`, `col_types` and
`output_path`.

`scripts/data_pipeline.R` can be used to manually trigger the refresh of
the data.

## Application

TODO - details about navigating the application

## Deployment

TODO - details about git actions and docker TODO - testing

## Development

### Project structure

    ├── app.R                 <- Shiny application
    ├── components            <- UI/Server components of app (shiny modules)
    ├── config                <- Project configurations. R and yaml files.
    │   ├── proj.R            <- Project configuration, e.g. project paths.  
    │   └── db_deps.yaml      <- Database connections and table names  
    ├── CovidDashboard.Rproj  <- R project file
    ├── docs                  <- Documentation and example code snippets
    ├── inst                  <- Additional files such as images
    │   └── assets            <- Images, etc.
    ├── data                  <- Data storage. (git ignored)
    │   ├── input             <- Save location for data to be ingested by application
    │   └── output            <- Save location for data exported from the application
    ├── Dockerfile            <- Docker image configuration
    ├── pages                 <- Pages for dashboard (shiny modules, made up of components)
    ├── queries               <- Database queries (e.g. SQL)
    ├── R                     <- R functions (all should be unit tested)
    ├── README.md             <- The top-level README for developers using this project.
    ├── renv                  <- renv local dependency management
    ├── renv.lock             <- describes the state of the project library
    ├── scripts               <- Scripts to be run outside of the application
    ├── tests                 <- Test related files and scripts
    │   ├── testthat          <- R unit testing
    │   └── testthat.R        <- Run R unit testing
    └── www                   <- javascript and css files

### Adding features

TODO - pages, components, functions, modules, scripts, tests, queries
TODO - less dependencies the better

### Developing outside of the Shiny framework

TODO - not recommended to used js and css in `www/`, but sometimes
required

### Conforming to existing codebase

Conforming to the existing style is very important (excluding times
where large refactoring is done). Developers should stick to already
used R packages if possible. E.g. use `dplyr` rather than `data.table`.
(`data.table` is amazing, but `dplyr` is used for this product).

All unit tests should use `testthat` style framework..
