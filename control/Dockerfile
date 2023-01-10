FROM golang:1.18-alpine as dog-import-build

RUN apk add --no-cache git
RUN git clone --depth=1 https://github.com/relaypro-open/terraform-provider-dog.git
WORKDIR terraform-provider-dog/dog-import
# pre-copy/cache go.mod for pre-downloading dependencies and only redownloading them in subsequent builds if they change
RUN go mod download
RUN go build
RUN find / -name dog-import -type f

FROM alpinelinux/ansible as deploy
RUN apk add --update --no-cache openssh bash vim git curl httpie bind-tools

RUN whoami

#ansible
RUN pip3 install pip credstash api-client --upgrade
RUN python3 -m pip install -e git+https://github.com/relaypro-open/dog_api_python.git#egg=dog_api_python
RUN mkdir -p /root/.ansible/plugins/connection
RUN git clone --depth=1 https://github.com/relaypro-open/dog_ansible_connection.git
#RUN cp /dog_ansible_connection/dog.py ~/.ansible/plugins/connection/dog.py
#TODO: get dog.py from git
COPY dog.py /root/.ansible/plugins/connection/ 
COPY ansible ansible

RUN ansible-galaxy collection install community.docker
RUN pip3 install requests

COPY --from=dog-import-build /go/terraform-provider-dog/dog-import/dog-import /bin/dog-import
#terraform
RUN curl https://releases.hashicorp.com/terraform/1.3.7/terraform_1.3.7_linux_amd64.zip --output terraform_1.3.7_linux_amd64.zip 
#COPY terraform_1.3.7_linux_amd64.zip terraform_1.3.7_linux_amd64.zip 
RUN ls -latr
RUN unzip terraform_1.3.7_linux_amd64.zip -d /bin/
COPY terraform terraform


RUN echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config
#RUN adduser -h /home/guest -s /bin/sh -D guest
RUN echo -n 'guest:guest' | chpasswd
ENTRYPOINT ["/entrypoint.sh"]
EXPOSE 22
COPY terraform_setup.sh /
COPY entrypoint.sh /
