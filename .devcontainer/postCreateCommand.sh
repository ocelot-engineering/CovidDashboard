#!/usr/bin/env bash

R -e "renv::restore(clean = TRUE, prompt = FALSE)"

Rscript ./scripts/data_pipeline.R