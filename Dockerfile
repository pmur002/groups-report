
# Base image
FROM ubuntu:20.04
MAINTAINER Paul Murrell <paul@stat.auckland.ac.nz>

# add CRAN PPA
RUN apt-get update && apt-get install -y apt-transport-https gnupg ca-certificates software-properties-common dirmngr
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
RUN add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/'

ARG DEBIAN_FRONTEND=noninteractive

# Install additional software
# R stuff
RUN apt-get update && apt-get install -y \
    r-base=4.3* 

# Install additional software
# R stuff
RUN apt-get update && apt-get install -y \
    xsltproc \
    libxml2-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    bibtex2html \
    subversion \
    libgit2-dev

ENV Rscript=Rscript

# For building the report
RUN apt-get update && apt-get install -y libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev libfontconfig1-dev libharfbuzz-dev libfribidi-dev
RUN Rscript -e 'install.packages(c("knitr", "devtools"), repos="https://cran.rstudio.com/")'
RUN Rscript -e 'library(devtools); install_version("xml2", "1.3.3", repos="https://cran.rstudio.com/")'
RUN apt-get update && apt-get install -y libpoppler-cpp-dev libmagick++-dev
RUN Rscript -e 'library(devtools); install_version("gdiff", "0.2-4", repos="https://cran.rstudio.com/")'

# Packages used in the report
RUN Rscript -e 'library(devtools); install_version("ggplot2", "3.3.6", repos="https://cran.rstudio.com/")'

# The main report package(s)



