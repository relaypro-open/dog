FROM kong

RUN whoami

USER root
RUN apk update && apk add curl vim httpie jq
COPY kong.yml kong.yml
RUN chown kong:kong kong.yml

USER kong
CMD kong start && http :8001/config config=@kong.yml
