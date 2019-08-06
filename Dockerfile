FROM perl:latest

RUN cpanm Carton \
    && mkdir -p /app
WORKDIR /app

ONBUILD COPY cpanfile* /usr/src/myapp
ONBUILD RUN carton install

ONBUILD COPY . /app
