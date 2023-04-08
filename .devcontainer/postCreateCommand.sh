#!/usr/bin/env bash

R -e "devtools::install_deps()"

Rscript ./dev/run-data-pipeline.R