FROM docker.io/ubuntu:24.04
RUN whoami

RUN ln -s /usr/share/zoneinfo/UTC /etc/localtime
RUN DEBIAN_FRONTEND=noninteractive apt-get update -y && apt-get install -y --no-install-recommends \
build-essential tzdata git ansible bash vim curl httpie python3-full python3-pip \
python3-virtualenv unzip make gcc jq software-properties-common

RUN add-apt-repository ppa:longsleep/golang-backports
RUN DEBIAN_FRONTEND=noninteractive apt-get update -y && apt-get install -y --no-install-recommends golang-1.25

#terraform-provider-dog
ARG CACHEBUST=10
RUN git clone --depth=1 https://github.com/relaypro-open/terraform-provider-dog.git
WORKDIR /terraform-provider-dog
#RUN sed -i "s/go 1.25/go 1.22/g" go.mod && make

#dog-import
WORKDIR /terraform-provider-dog/dog-import
# pre-copy/cache go.mod for pre-downloading dependencies and only redownloading them in subsequent builds if they change
RUN /usr/lib/go-1.25/bin/go mod download
RUN /usr/lib/go-1.25/bin/go build
RUN find / -name dog-import -type f
RUN cp /terraform-provider-dog/dog-import/dog-import /bin/dog-import
WORKDIR /

#ansible
COPY ansible ansible
#RUN pip3 install pip --upgrade

RUN python3 -m virtualenv ve

RUN /ve/bin/pip install pyjwt cryptography ipython credstash deepmerge PyYaml
RUN /ve/bin/pip install -e git+https://github.com/Phonebooth/api-client.git#egg=apiclient
RUN /ve/bin/pip install -e git+https://github.com/relaypro-open/dog_api_python.git#egg=dog_api_python
RUN ansible-galaxy collection install git+https://github.com/relaypro-open/community.dog.git
COPY dog.yml /ansible/dog.yml

#rethinkdb
RUN /ve/bin/pip install rethinkdb python-benedict
RUN mkdir scripts
COPY scripts scripts

#terraform
RUN curl https://releases.hashicorp.com/terraform/1.5.7/terraform_1.5.7_linux_arm64.zip --output terraform_1.5.7_linux_arm64.zip
#COPY terraform_1.3.7_linux_amd64.zip terraform_1.3.7_linux_amd64.zip
RUN ls -latr
RUN unzip terraform_1.5.7_linux_arm64.zip -d /bin/
COPY terraform terraform

#.terraformrc set to use local copy of provider
#COPY terraformrc /root/.terraformrc

COPY scripts scripts/
RUN chmod u+x scripts/entrypoint.sh
ENTRYPOINT [ "scripts/entrypoint.sh" ]
