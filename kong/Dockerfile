FROM kong

RUN whoami

USER root
RUN apk update && apk add curl vim httpie jq
COPY kong.yml kong.yml
RUN chown kong:kong kong.yml

USER kong
RUN which kong
RUN which http
#CMD /usr/local/bin/kong start && sleep 10 && /usr/bin/http :8001/config config=@kong.yml
CMD kong start
