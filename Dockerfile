FROM alpine:latest

ENV DOCKER_VERSION 17.06.2-ce

RUN apk --no-cache update && apk --no-cache upgrade && \
    apk --no-cache add jq darkhttpd tar curl && \
    mkdir -p /opt/docker && \
    curl -sL https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz | tar xz -C /opt/docker --strip-components=1

RUN mkdir -p /opt/check && echo test > /opt/check/index.html

VOLUME /opt/check

EXPOSE 80

LABEL url=https://api.github.com/repos/xbmc/xbmc/releases/latest
LABEL version=${DOCKER_VERSION}
LABEL name=check

CMD darkhttpd /opt/check --port 80
