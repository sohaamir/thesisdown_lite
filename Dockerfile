#!/bin/bash

# Install system dependencies
apt-get update && apt-get install -y \
    libxml2-dev \
    libcairo2-dev \
    libgit2-dev \
    libglpk40 \
    libglu1-mesa-dev \
    libgmp3-dev \
    libgsl0-dev \
    libhdf5-dev \
    libmpfr-dev \
    libssl-dev \
    libv8-dev \
    libzmq3-dev \
    pandoc \
    pandoc-citeproc \
    wget \
    unzip \
    gcc \
    make \
    libc-dev \
    texlive-fonts-extra \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set the timezone
ln -snf /usr/share/zoneinfo/Europe/London /etc/localtime && echo "Europe/London" > /etc/timezone

# Install and configure TinyTeX
R -e "tinytex::install_tinytex(force = TRUE)"
R -e "tinytex::tlmgr_install(c('lm-math', 'pdftex', 'xetex', 'luatex'))"
R -e "tinytex::tlmgr_update()"

# Install the remotes package
R -e "install.packages('remotes', repos='https://cloud.r-project.org/')"

# Install R package from GitHub
R -e "remotes::install_github('lcreteig/amsterdown')"
