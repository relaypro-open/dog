FROM rabbitmq:management

RUN apt-get update -y && apt-get install -y jq curl

RUN mkdir -p /etc/rabbitmq/certs \
	&& mkdir -p /etc/rabbitmq/private \
	&& chmod 700 /etc/rabbitmq/private

COPY 20-ssl.conf /etc/rabbitmq/conf.d/

COPY csc_certs.sh /etc/rabbitmq/ 

RUN chown -R rabbitmq:rabbitmq /etc/rabbitmq

CMD /bin/bash -c "/etc/rabbitmq/csc_certs.sh" && rabbitmq-server
