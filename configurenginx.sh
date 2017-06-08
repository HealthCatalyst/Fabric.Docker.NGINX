#!/bin/bash
echo "configuring nginx..."
host=$1
remoteport=$2
cat > /etc/nginx/conf.d/default.conf << EOF
upstream dotnet {
	server $host:$remoteport;
}

server {

	listen 80;
	location / {
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
	}
}
EOF
echo "nginx configured as:"
cat /etc/nginx/conf.d/default.conf
