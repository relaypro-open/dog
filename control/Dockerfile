FROM alpinelinux/ansible


RUN whoami
RUN apk add --update --no-cache openssh bash vim git curl httpie

RUN pip3 install pip credstash api-client --upgrade
RUN python3 -m pip install -e git+https://github.com/relaypro-open/dog_api_python.git#egg=dog_api_python
#RUN git clone https://github.com/relaypro-open/dog_ansible_connection.git
#RUN mkdir -p ~/.ansible/plugins/connection && cp dog_ansible_connection/dog.py ~/.ansible/plugins/connection/
RUN mkdir -p ~/.ansible/plugins/connection
RUN git checkout https://github.com/relaypro-open/dog_ansible_connection.git 
COPY dog_ansible_connection/dog.py .ansible/plugins/connection/
COPY ansible ansible

RUN echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config
#RUN adduser -h /home/guest -s /bin/sh -D guest
RUN echo -n 'guest:guest' | chpasswd
ENTRYPOINT ["/entrypoint.sh"]
EXPOSE 22
COPY entrypoint.sh /
