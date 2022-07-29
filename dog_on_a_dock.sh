#!/bin/bash
git clone https://github.com/relaypro-open/dog_agent.git
cd dog_agent
git pull
git checkout feature/ansible_connection
cd ..

git clone https://github.com/relaypro-open/dog_trainer.git
cd dog_trainer
git pull
git checkout feature/ansible_connection
cd ..

git clone https://github.com/relaypro-open/dog_park.git
cd dog_park
git pull
cd ..

docker compose build
docker compose up

docker container ls
