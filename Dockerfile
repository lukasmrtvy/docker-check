FROM alpine:3.7

COPY exec.sh /opt/check/

RUN set -xe && \
    echo "@testing http://nl.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories && \
    apk --no-cache update && \
 #   apk add --upgrade apk-tools@edge && \
    apk --no-cache add jq darkhttpd curl tzdata bash && \
    apk --no-cache add moreutils@testing && \
    mkdir -p /opt/check && echo "Not populate yet" > /opt/check/index.html && \
    echo '0  *  *  *  *    /opt/check/exec.sh' >> /etc/crontabs/root  && \
    chmod +x /opt/check/exec.sh 

WORKDIR  /opt/check/

EXPOSE 80

CMD darkhttpd /opt/check --port 80 --daemon && crond -f
