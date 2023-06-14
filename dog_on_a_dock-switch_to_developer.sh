#!/bin/bash
cd dog_agent_ex
git remote remove origin
git remote add git@github.com:relaypro-open/dog_agent_ex.git
git push --set-upstream origin main
cd ..

cd dog_agent
git remote remove origin
git remote add origin git@github.com:relaypro-open/dog_agent.git
git push --set-upstream origin feature/ansible_connection
cd ..

cd dog_trainer
git remote remove origin
git remote add origin git@github.com:relaypro-open/dog_trainer.git
git push --set-upstream origin feature/ansible_connection
cd ..

cd dog_park
git remote remove origin
git remote add origin git@github.com:relaypro-open/dog_park.git
git push --set-upstream origin master
cd ..

cd csc
git remote remove origin
git remote add origin git@github.com:relaypro-open/csc.git
git push --set-upstream origin master
cd ..
