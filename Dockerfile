#
# Image build takes ~25 mins
#

FROM rocker/shiny

COPY . /srv/shiny-server/CovidDashboard

WORKDIR /srv/shiny-server/CovidDashboard

# remove demo apps
# RUN ["rm", "-r", "/srv/shiny-server/*"]

# default shiny port
EXPOSE 3838

# update package list
RUN ["apt", "update"]

# install linux packages
RUN ["apt", "install", "-y", "libssl-dev", "libgdal-dev", "libudunits2-dev", "nano"]

# install renv for dependency management
RUN ["R", "-e", "install.packages('renv')"]

# install R packages
RUN ["R", "-e", "renv::restore()"]
RUN ["R", "-e", "renv::isolate()"]

# Download data
CMD ["Rscript", "scripts/data_pipeline.R"]