FROM ubuntu:22.04
RUN whoami

RUN ln -s /usr/share/zoneinfo/UTC /etc/localtime
RUN DEBIAN_FRONTEND=noninteractive apt-get update -y && apt-get install -y --no-install-recommends tzdata git golang ansible bash vim curl httpie python3-pip unzip make gcc jq

#terraform-provider-dog
RUN git clone --depth=1 https://github.com/relaypro-open/terraform-provider-dog.git
WORKDIR /terraform-provider-dog
RUN make

#dog-import
WORKDIR /terraform-provider-dog/dog-import
# pre-copy/cache go.mod for pre-downloading dependencies and only redownloading them in subsequent builds if they change
RUN go mod download
RUN go build
RUN find / -name dog-import -type f
RUN cp /terraform-provider-dog/dog-import/dog-import /bin/dog-import
WORKDIR /

#ansible
COPY ansible ansible
RUN pip3 install pip credstash api-client --upgrade
RUN python3 -m pip install -e git+https://github.com/relaypro-open/dog_api_python.git#egg=dog_api_python
RUN ansible-galaxy collection install git+https://github.com/relaypro-open/community.dog.git
COPY dog.yml /ansible/dog.yml

#terraform
RUN curl https://releases.hashicorp.com/terraform/1.3.7/terraform_1.3.7_linux_amd64.zip --output terraform_1.3.7_linux_amd64.zip 
#COPY terraform_1.3.7_linux_amd64.zip terraform_1.3.7_linux_amd64.zip 
RUN ls -latr
RUN unzip terraform_1.3.7_linux_amd64.zip -d /bin/
COPY terraform terraform

#.terraformrc set to use local copy of provider
COPY terraformrc /root/.terraformrc

ARG cachebust2
COPY terraform_setup.sh /
CMD /bin/bash -c "/terraform_setup.sh" && /bin/bash -c "sleep infinity"
#CMD /bin/bash -c "sleep infinity"
