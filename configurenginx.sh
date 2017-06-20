#!/bin/bash

# Usage:
#    configurenginx.sh [remote_host] [remote_port] [cert_secret] [cert_key_secret]
#
#    - remote_host  required, specifies the hostname of the proxied application
#    - remote_port required, specifies the port of the proxies application
#    - cert_secret  optional, defines the name of the docker secret for the certificate
#    - cert_key_secret  optional, defines the name of the docker secret for the certificate key

###############################################################################
echo "configuring nginx..."
remote_host=$1
remote_port=$2

cert_secret=$3
cert_key_secret=$4

locationdef="location / {
                proxy_pass http://dotnet;
                proxy_http_version 1.1;
		proxy_set_header Upgrade \$http_upgrade;
		proxy_set_header Connection keep-alive;
		proxy_set_header Host \$host;
		proxy_set_header X-Real-IP \$remote_addr;
		proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
		proxy_set_header X-Forwarded-Proto \$scheme;
		proxy_set_header X-Forwarded-Host \$server_name;
		proxy_cache_bypass \$http_upgrade;
       }"

if ! [ -z "$cert_secret"  ] && ! [ -z "$cert_key_secret" ]; then
    echo "certificates configured, setting up server on port 443"
    listendef="listen 443 ssl http2 default_server;
        listen [::]:443 ssl http2 default_server;

	ssl_certificate /run/secrets/$cert_secret;
	ssl_certificate_key /run/secrets/$cert_key_secret;"
else
    echo "no certificates configured, setting up server on port 80"
    listendef="listen 80;"
fi
cat > /etc/nginx/conf.d/default.conf << EOF
upstream dotnet {
	server $remote_host:$remote_port;
}

server {

	$listendef
	$locationdef
}
EOF
echo "nginx configured as:"
cat /etc/nginx/conf.d/default.conf
