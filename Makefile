VERSION=0.0.1
OS_ARCH=linux_amd64

default: 
	docker-compose -f docker-compose.local_deploy.yml build

build:
	docker-compose -f docker-compose.local_deploy.yml build

up:	
	docker-compose -f docker-compose.local_deploy.yml up

dog_trainer_rebuild:
	docker-compose -f docker-compose.local_deploy.yml up -d --force-recreate --no-deps --build dog_trainer

dog_agent_rebuild:
	docker-compose -f docker-compose.local_deploy.yml up -d --force-recreate --no-deps --build dog_agent

dog_agent_ex_rebuild:
	docker-compose -f docker-compose.local_deploy.yml up -d --force-recreate --no-deps --build dog_agent_ex

dog_park_rebuild:
	docker-compose -f docker-compose.local_deploy.yml up -d --force-recreate --no-deps --build dog_park

kong_rebuild:
	docker-compose -f docker-compose.local_deploy.yml up -d --force-recreate --no-deps --build kong

rabbitmq_rebuild:
	docker-compose -f docker-compose.local_deploy.yml up -d --force-recreate --no-deps --build rabbitmq

csc_rebuild:
	docker-compose -f docker-compose.local_deploy.yml up -d --force-recreate --no-deps --build csc

control_rebuild:
	docker-compose -f docker-compose.local_deploy.yml up -d --force-recreate --no-deps --build control

control_build:
	 docker-compose -f docker-compose.local_deploy.yml build --no-cache control

dog_trainer_console:
	docker exec -it dog_trainer /opt/dog_trainer/bin/dog_trainer remote_console

dog_trainer_shell:
	docker exec -it dog_trainer /bin/bash
