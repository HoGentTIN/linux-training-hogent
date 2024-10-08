# Dockerfile with the necessary tools to build the PDFs and mkdocs sites
# for the linux-training-hogent repository.

FROM ubuntu:24.04
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install --yes --no-install-recommends \
        biber \
        git \
        latexmk \
        lmodern \
        make \
        mkdocs \
        mkdocs-material \
        pandoc \
        pipx \
        python3-pygments \
        python3-pymdownx \
        texlive-bibtex-extra \
        texlive-fonts-recommended \
        texlive-lang-european \
        texlive-latex-base \
        texlive-latex-extra \
        texlive-xetex \
        wget && \
    pipx install shyaml && \
    pipx ensurepath && \
    rm -rf /var/lib/apt/lists/*
# Install fonts for the HOGENT corporate style
RUN cd /tmp && \
    git clone https://github.com/HoGentTIN/latex-hogent-beamer.git && \
    cp -r latex-hogent-beamer/fonts/* /usr/share/fonts/ && \
    rm -rf /tmp/latex-hogent-beamer
WORKDIR /app