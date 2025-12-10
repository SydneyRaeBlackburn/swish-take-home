# syntax=docker/dockerfile:1

##### PYTHON3 BUILD STAGE #####
FROM python:3.13-slim AS build-py3

RUN apt-get update && apt-get upgrade
  # && apt-get install -y --no-install-recommends
  
WORKDIR /app
COPY requirements/py3-requirements.txt .
RUN pip wheel --wheel-dir /py3-wheels -r py3-requirements.txt

##### PYTHON2 BUILD STAGE #####
FROM python:2.7-slim AS build-py2

# apt update fails, I assume because python2 is at EOL

WORKDIR /app
COPY requirements/py2-requirements.txt .
RUN pip wheel --wheel-dir /py2-wheels -r py2-requirements.txt

##### PYTHON2 BINARY DOWNLOAD #####
FROM ubuntu:24.04 AS py2-download

WORKDIR /py2

RUN apt update && apt upgrade && apt install -y --no-install-recommends \
  wget \
  curl \
  ca-certificates

RUN wget https://www.python.org/ftp/python/2.7.18/Python-2.7.18.tgz && tar xvf Python-2.7.18.tgz
RUN curl https://bootstrap.pypa.io/pip/2.7/get-pip.py -o get-pip.py

##### FINAL IMAGE #####
FROM ubuntu:24.04

# necessary to install python3.13
RUN apt update && apt upgrade && apt install --no-install-recommends -y \
  software-properties-common
RUN add-apt-repository ppa:deadsnakes/ppa

RUN apt update && apt install --no-install-recommends -y \
  python3.13 \
  python3.13-venv \
  r-base \
  build-essential \
  libssl-dev \
  tk-dev 
  
# copy built dependencies
COPY --from=build-py3 /py3-wheels /py3-wheels
COPY --from=build-py2 /py2-wheels /py2-wheels
COPY --from=py2-download /py2 /py2

# configure python 2.7
WORKDIR /py2/Python-2.7.18
RUN ./configure --prefix=/opt/python2.7 && make -j$(nproc) && make install
ENV PATH="/opt/python2.7/bin:$PATH"
RUN python2.7 /py2/get-pip.py && pip2.7 install --no-cache-dir /py2-wheels/*

# configure python3.13
RUN python3.13 -m venv /py3-venv && /py3-venv/bin/pip install --no-cache-dir /py3-wheels/*
ENV PATH="/py3-venv/bin:$PATH"

WORKDIR /app
COPY . .

# install R requirements
RUN apt update && cat requirements/r-requirements-bins.txt | xargs apt install --no-install-recommends -y \
  && rm -rf /var/lib/apt/lists/*
RUN Rscript requirements/r-requirements.R

EXPOSE 5001