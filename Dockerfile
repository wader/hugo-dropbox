FROM golang:1.6
MAINTAINER Mattias Wadman mattias.wadman@gmail.com

ENV DROPBOX_FOLDER="site"

ENV HOME=/app
ENV LC_ALL="en_US.UTF-8"

RUN DEBIAN_FRONTEND=noninteractive \
  apt-get update && \
  apt-get -y install \
    locales \
    nginx

# make sure utf-8 works in filenames etc
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
RUN locale-gen

RUN mkdir /app

ENV GOPATH=/app/go
RUN go get \
  github.com/cortesi/modd/cmd/modd \
  github.com/spf13/hugo

# download dropbox client deamon
RUN wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf - -C /app

RUN mkdir -p /app/.dropbox /app/Dropbox
COPY run_hugo nginx.conf modd.conf /app/
RUN chown -R nobody:nogroup /app

WORKDIR /app
USER nobody

VOLUME ["/app/.dropbox", "/app/Dropbox"]
EXPOSE 8080
CMD ["/app/go/bin/modd"]
