#!/usr/bin/env bash

R -e "devtools::install_deps()"

Rscript ./docker/data_pipeline.R