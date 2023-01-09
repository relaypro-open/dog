FROM alpinelinux/ansible


RUN whoami
RUN apk add --update --no-cache openssh bash vim git curl httpie

#ansible
RUN pip3 install pip credstash api-client --upgrade
RUN python3 -m pip install -e git+https://github.com/relaypro-open/dog_api_python.git#egg=dog_api_python
RUN mkdir -p ~/.ansible/plugins/connection
RUN git clone https://github.com/relaypro-open/dog_ansible_connection.git 
RUN cp dog_ansible_connection/dog.py ~/.ansible/plugins/connection/dog.py
COPY ansible ansible

#terraform
RUN curl https://releases.hashicorp.com/terraform/1.3.7/terraform_1.3.7_linux_amd64.zip --output terraform_1.3.7_linux_amd64.zip 
RUN unzip terraform_1.3.7_linux_amd64.zip
RUN mv terraform /usr/bin/terraform

RUN echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config
#RUN adduser -h /home/guest -s /bin/sh -D guest
RUN echo -n 'guest:guest' | chpasswd
ENTRYPOINT ["/entrypoint.sh"]
EXPOSE 22
COPY entrypoint.sh /
