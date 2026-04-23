#FROM kong/kong:latest-ubuntu
FROM --platform=linux/amd64 docker.io/kong/kong:2.8-ubuntu

RUN whoami

USER root
RUN apt-get update && apt-get install -y curl vim-tiny httpie jq
#RUN luarocks install kong-upstream-jwt-extended
#RUN apk update && apk add curl vim httpie jq
COPY kong.yml kong.yml
RUN chown kong:kong kong.yml
#COPY csc_certs.sh /usr/local/openresty/bin/csc_certs.sh
#RUN chmod u+x /usr/local/openresty/bin/csc_certs.sh

USER kong
RUN which kong
RUN which http
#CMD /usr/local/bin/kong start && sleep 10 && /usr/bin/http :8001/config config=@kong.yml
CMD kong start
#CMD /bin/bash -c "/usr/local/openresty/bin/csc_certs.sh" && kong start
