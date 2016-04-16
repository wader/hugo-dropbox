FROM debian:jessie
MAINTAINER Mattias Wadman mattias.wadman@gmail.com

ENV DROPBOX_FOLDER="site"

ENV HOME=/app
ENV LC_ALL="en_US.UTF-8"

RUN DEBIAN_FRONTEND=noninteractive \
  apt-get update && \
  apt-get -y install wget locales nginx && \
  apt-get clean

# make sure utf-8 works in filenames etc
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
RUN locale-gen

RUN mkdir /app
WORKDIR /app

RUN \
  wget -O - "https://github.com/krallin/tini/releases/download/v0.9.0/tini" > /usr/local/bin/tini && \
  chmod a+x /usr/local/bin/tini && \
  wget -O - "https://github.com/cortesi/modd/releases/download/v0.2/modd-0.2-linux64.tgz" | tar xfz - && \
  mv tmp/modd-0.2-linux64/modd /usr/local/bin && \
  rm -rf tmp && \
  wget -O - "https://github.com/spf13/hugo/releases/download/v0.15/hugo_0.15_linux_amd64.tar.gz" | tar xfz - && \
  mv hugo_0.15_linux_amd64/hugo_0.15_linux_amd64 /usr/local/bin/hugo && \
  rm -rf hugo_0.15_linux_amd64 && \
  wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf - -C /app

RUN mkdir -p /app/.dropbox /app/Dropbox
COPY run_hugo nginx.conf modd.conf /app/
RUN chown -R nobody:nogroup /app

USER nobody

VOLUME ["/app/.dropbox", "/app/Dropbox"]
EXPOSE 8080
CMD ["/usr/local/bin/tini", "--", "/usr/local/bin/modd"]
