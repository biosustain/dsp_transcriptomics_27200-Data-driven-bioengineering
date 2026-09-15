FROM ghcr.io/biosustain/dsp_transcriptomics_training:latest

# System library needed to build the pbdZMQ R package (IRkernel dependency),
# plus Python/pip to install Jupyter itself.
RUN apt-get update && apt-get install -y --no-install-recommends \
    libzmq3-dev \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install --no-cache-dir --break-system-packages jupyterlab

# R packages referenced by the workshop scripts that aren't in the base image yet,
# plus the R Jupyter kernel (IRkernel).
RUN Rscript -e "install.packages(c('heatmaply', 'pbdZMQ', 'IRkernel'), repos = 'https://cloud.r-project.org')"

RUN Rscript -e "BiocManager::install('org.EcK12.eg.db', update = FALSE, ask = FALSE)"

RUN Rscript -e "IRkernel::installspec(name = 'ir', displayname = 'R', user = FALSE)"
