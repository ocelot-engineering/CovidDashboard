#
# Image build takes ~25 mins
#

FROM rocker/shiny

COPY . /srv/shiny-server/CovidDashboard

WORKDIR /srv/shiny-server/CovidDashboard

RUN ["rm", "-r", "/srv/shiny-server/*"] # Remove demo apps

EXPOSE 3838 # default shiny port

RUN ["apt", "update"] # update package list

RUN ["apt", "install", "-y", "libssl-dev", "libgdal-dev", "libudunits2-dev", "nano"] # install linux packages

RUN ["R", "-e", "install.packages('renv')"] # install renv for dependency management

RUN ["R", "-e", "install.packages('shinydashboard')"] # install renv for dependency management
    
RUN ["R", "-e", "renv::restore()"] # install R packages

RUN ["R", "-e", "renv::isolate()"] # install R packages

CMD ["Rscript", "scripts/data_pipeline.R"] # Download data
