# Use the rocker/rstudio image as the base
FROM rocker/rstudio:4.3.2

# Install system dependencies
RUN apt-get update && apt-get install -y \
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
ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install and configure TinyTeX
RUN R -e "install.packages('tinytex', repos='https://cloud.r-project.org/')" \
    && R -e "tinytex::install_tinytex(force = TRUE)" \
    && R -e "tinytex::tlmgr_install(c('lm-math', 'pdftex', 'xetex', 'luatex'))" \
    && R -e "tinytex::tlmgr_update()"

# Set the necessary environment variables for TinyTeX
ENV PATH="/usr/local/texlive/bin/x86_64-linux:${PATH}"
ENV PATH="/home/rstudio/.TinyTeX/bin/x86_64-linux:${PATH}"

# Install R packages from CRAN
RUN R -e "install.packages(c('ggsignif', 'gridExtra', 'plan'), repos='https://cloud.r-project.org/')"

# Install the remotes package
RUN R -e "install.packages('remotes', repos='https://cloud.r-project.org/')"

# Install R package from GitHub
RUN R -e "remotes::install_github('lcreteig/amsterdown')"

# Uncomment this if you do NOT want to make changes to the project on your local machine
# COPY . /your_project_directory

# Set the working directory
WORKDIR /home/rstudio

# Start the RStudio server
CMD ["/init"]