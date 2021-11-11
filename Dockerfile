
# Base image
FROM ubuntu:18.04
MAINTAINER Paul Murrell <paul@stat.auckland.ac.nz>

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=NZ
RUN apt-get update && apt-get install -y tzdata

# Building R from source
RUN apt-get update && apt-get install -y \      
    subversion \
    r-base-dev \
    texlive-full \
    libcairo2-dev \
    libpcre2-dev \
    libcurl4-openssl-dev
# Get R commit r
RUN svn co -r81125 https://svn.r-project.org/R/trunk/ R
RUN cd R; ./configure --with-x=no --without-recommended-packages 
RUN cd R; make

# For building the report
RUN apt-get update && apt-get install -y \
    xsltproc \
    bibtex2html 
RUN apt-get install -y \
    libxml2-dev \
    libssl-dev \
    libssh2-1-dev \
    libgit2-dev 
RUN R/bin/Rscript -e 'install.packages(c("knitr", "devtools"), repos="https://cran.rstudio.com/")'
RUN R/bin/Rscript -e 'library(devtools); install_version("xml2", "1.1.1", repos="https://cran.rstudio.com/")'

# Packages used in the report
RUN R/bin/Rscript -e 'install.packages("devtools", repos="https://cran.rstudio.com/")'
RUN R/bin/Rscript -e 'library(devtools); install_version("ggplot2", "3.3.2", repos="https://cran.rstudio.com/")'

# The main report package(s)



