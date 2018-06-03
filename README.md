# docker-check


`docker rm -f check; docker run -d -v /var/run/docker.sock:/var/run/docker.sock:ro -p 8811:80 --name check check`
