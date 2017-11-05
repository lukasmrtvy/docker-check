FROM alpine:latest

COPY exec.sh /opt/check/

RUN apk --no-cache update && \
    apk --no-cache add jq darkhttpd curl tzdata && \
    mkdir -p /opt/check && echo "Not populate yet" > /opt/check/index.html && \
    echo '0  *  *  *  *    /opt/check/exec.sh' >> /etc/crontabs/root  && \
    chmod +x /opt/check/exec.sh 

WORKDIR  /opt/check/

EXPOSE 80

CMD darkhttpd /opt/check --port 80 --daemon && crond -f
