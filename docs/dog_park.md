<p align="center">
  <img src="../images/dog-segmented-green.network-200x200.png">
</p>

<h1>dog_park</h1>

dog_agent is the web gui component of [dog](https://github.com/Phonebooth/dog),
a centralized firewall management system.

- [Runtime Dependencies](#runtime-dependencies)
- [Runtime Dependencies Setup](#runtime-dependencies-setup)
- [Build Dependencies](#build-dependencies)
- [Deploy Configuration](#deploy-configuration)
- [Build](#build-release)
- [Deploy](#deploy)
- [Run](#run)

## Runtime Dependencies

- linux 4.x+ (Ubuntu 16.04+ tested)
- web server (nginx tested)

## Build Dependencies

- nodejs 12.x
- yarn 1.16.x

- Ubuntu:

```bash
#nodejs

curl -sL https://deb.nodesource.com/setup_12.x | bash -
apt install nodejs 
#yarn

npm install --global yarn@1.16.0
```

## Deploy Configuration

```bash
apt install virtualenv
virtualenv /opt/dog_env
source /opt/dog_env/bin/activate
pip install -r /opt/dog/requirements.txt
cd /opt/dog
ansible.sh
```

## Build

```bash
#REACT_APP_DOG_API must match certificate address if using https
REACT_APP_DOG_API_HOST='http://localhost:3000' yarn build dev
cd _build
tar cd dog_park.tgz *
```

## Deploy

Copy tar to web server system, extract to web root

## Sample Nginx Configuration

- Protect with an authentication proxy: [oauth2-proxy](https://oauth2-proxy.github.io/oauth2-proxy/)
- Configure your web server to proxy /api to dog_trainer at [http://localhost:7070/api/](http://localhost:7070/api/)
- Create a directory /opt/flan_api
- ```echo "[]" > /opt/flan/flan_api/flan_ips```

example nginx config:

```nginx
{
  server {
    listen 3000 default_server;
    listen [::]:3000 default_server;

    location /api/ {
        auth_request /oauth2/auth;
        error_page 401 = /oauth2/sign_in;
    
        # pass information via X-User and X-Email headers to backend,
        # requires running with --set-xauthrequest flag
        auth_request_set $user   $upstream_http_x_auth_request_user;
        auth_request_set $email  $upstream_http_x_auth_request_email;
        proxy_set_header X-User  $user;
        proxy_set_header X-Email $email;
    
        # if you enabled --cookie-refresh, this is needed for it to work with auth_request
        proxy_pass http://localhost:7070/api/;
    
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    
        proxy_set_header  Host $host;
        proxy_set_header   X-Real-IP        $remote_addr;
        proxy_set_header   X-Real-Port      $remote_port;
        proxy_set_header   X-Forwarded-Proto $scheme;
    }

    location /flan_api/ {
        root /opt/flan;
        # pass information via X-User and X-Email headers to backend,
        # requires running with --set-xauthrequest flag
        auth_request_set $user   $upstream_http_x_auth_request_user;
        auth_request_set $email  $upstream_http_x_auth_request_email;
        proxy_set_header X-User  $user;
        proxy_set_header X-Email $email;
    
        # if you enabled --cookie-refresh, this is needed for it to work with auth_request
        auth_request_set $auth_cookie $upstream_http_set_cookie;
        add_header Set-Cookie $auth_cookie;
    }

    location / {
        root   /opt/dog_park;
        index  index.html index.htm;

        try_files $uri $uri/ /index.html;
    } 
}
```

## Run

[http://localhost:3000](http://localhost:3000)
