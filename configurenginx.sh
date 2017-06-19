#!/bin/bash
echo "configuring nginx..."
host=$1
remoteport=$2

certificate=$3
certificate_key=$4

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

if ! [ -z "$certificate"  ] && ! [ -z "$certificate_key" ]; then
    echo "certificates configured, setting up server on port 443"
    listendef="listen 443 ssl http2 default_server;
        listen [::]:443 ssl http2 default_server;

	ssl_certificate /run/secrets/$certificate;
	ssl_certificate_key /run/secrets/$certificate_key;"
else
    echo "no certificates configured, setting up server on port 80"
    listendef="listen 80;"
fi
cat > /etc/nginx/conf.d/default.conf << EOF
upstream dotnet {
	server $host:$remoteport;
}

server {

	$listendef
	$locationdef
}
EOF
echo "nginx configured as:"
cat /etc/nginx/conf.d/default.conf
