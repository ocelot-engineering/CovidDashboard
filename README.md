# CovidDashboard

## Project structure
```
├── app.R                 <- Shiny application
├── components            <- UI/Server components of app (shiny modules)
├── config                <- Project configurations. R and yaml files.
│   ├── proj.R            <- Project configuration, e.g. project paths.  
│   └── db_deps.yaml      <- Database connections and table names  
├── CovidDashboard.Rproj  <- R project file
├── data                  <- Data storage. (git ignored)
│   ├── input             <- Save location for data to be ingested by application
│   └── output            <- Save location for data exported from the application
├── docker                <- Docker configuration
├── pages                 <- Pages for dashboard (shiny modules, made up of components)
├── queries               <- Database queries (e.g. SQL)
├── R                     <- R functions (all should be unit tested)
├── README.md             <- The top-level README for developers using this project.
├── renv                  <- renv local dependency management
├── renv.lock             <- describes the state of the project library
├── scripts               <- Scripts to be run outside of the application
├── tests                 <- Test related files and scripts
│   ├── cypress           <- JavaScript end to end testing   
│   ├── testthat          <- R unit testing
│   └── testthat.R        <- Run R unit testing
└── www                   <- javascript and css files
```
