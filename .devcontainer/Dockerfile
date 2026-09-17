FROM mcr.microsoft.com/devcontainers/base:noble
WORKDIR /home

# Base system + R + nextflow. Self-contained on purpose: this does not depend
# on any other repo's published image, so it keeps building even if that
# other repo changes or disappears.
RUN apt-get update \
    && apt-get install -y \
        openjdk-21-jre \
        python3-venv \
        python3-pip \
        libzmq3-dev \
        r-base \
        r-base-dev \
        r-cran-dplyr \
        r-cran-ggplot2 \
        r-cran-ggrepel \
        r-cran-rcolorbrewer \
        r-cran-rmarkdown \
        r-cran-tidyr \
        libcurl4-openssl-dev \
        libssl-dev \
        libxml2-dev \
        libfontconfig1-dev \
        libharfbuzz-dev \
        libfribidi-dev \
        libfreetype6-dev \
        libpng-dev \
        libtiff5-dev \
        libjpeg-dev \
    && curl -L -s -o /usr/local/bin/nextflow \
        https://github.com/nextflow-io/nextflow/releases/download/v25.10.4/nextflow-25.10.4-dist \
    && chmod +x /usr/local/bin/nextflow \
    && ln -s /usr/bin/python3 /usr/bin/python \
    && chmod -R 777 /usr/local/lib/R/site-library

# Jupyter (R kernel set up below) plus a Python kernel and a standard
# data-science stack, ahead of converting the Rmd scripts to Python notebooks.
RUN pip3 install --no-cache-dir --break-system-packages \
    jupyterlab \
    ipykernel \
    pandas \
    numpy \
    matplotlib \
    seaborn \
    scipy \
    statsmodels \
    scikit-learn

RUN python3 -m ipykernel install --name python3 --display-name "Python 3" --sys-prefix

# AI coding agents for the students to experiment with (see the
# "AI assistants in your Codespace" section of the course book).
# Node is only needed to install and run them.
RUN apt-get update \
    && apt-get install -y nodejs npm \
    && npm install -g @anthropic-ai/claude-code @openai/codex

COPY install_packages.R /tmp/install_packages.R
RUN Rscript /tmp/install_packages.R && rm /tmp/install_packages.R

RUN Rscript -e "IRkernel::installspec(name = 'ir', displayname = 'R', user = FALSE)"
