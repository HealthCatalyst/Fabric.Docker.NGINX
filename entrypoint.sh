#!/bin/bash

echo "cert path: /run/secrets/$CERTIFICATE"
echo "cert_key path: /run/secrets/$CERTIFICATE_KEY"

if ! [ -z "$CERTIFICATE" ] && ! [ -z "$CERTIFICATE_KEY" ]; then
	./opt/install/configurenginx.sh $HOST $REMOTEPORT $CERTIFICATE $CERTIFICATE_KEY
else
	./opt/install/configurenginx.sh $HOST $REMOTEPORT
fi

exec nginx -g "daemon off;"
