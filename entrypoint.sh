#!/bin/bash
./opt/install/configurenginx.sh $HOST $REMOTEPORT
exec nginx -g "daemon off;"
