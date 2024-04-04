FROM continuumio/miniconda3:latest

WORKDIR /app

RUN conda install -y -c conda-forge qvina

ENTRYPOINT [ "tail", "-f", "/dev/null" ]

