# Use an appropriate base image with R pre-installed
FROM rocker/verse:4.3.2

# Set the environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install additional system dependencies
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
RUN ln -snf /usr/share/zoneinfo/Europe/London /etc/localtime && echo "Europe/London" > /etc/timezone

# Install TinyTeX
RUN Rscript -e "install.packages('tinytex', repos='https://cloud.r-project.org/')"
RUN Rscript -e "tinytex::install_tinytex(force = TRUE)"
RUN Rscript -e "tinytex::tlmgr_install(c('lm-math', 'pdftex', 'xetex', 'luatex'))"
RUN Rscript -e "tinytex::tlmgr_update()"

# Install the remotes package
RUN Rscript -e "install.packages('remotes', repos='https://cloud.r-project.org/')"

# Install R package from GitHub
RUN Rscript -e "remotes::install_github('lcreteig/amsterdown')"

# Copy the repository contents
COPY . /home/rstudio/

# Set the working directory
WORKDIR /home/rstudio/

# Change ownership of the repository directory
RUN chown -R rstudio:rstudio /home/rstudio/
