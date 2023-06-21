#!/bin/bash

if [ -n $DOMAIN ] && [ ! $DOMAIN = localhost ] && [ ! -f /etc/letsencrypt/archive/$DOMAIN/fullchain.pem ]; then
    certbot certonly --nginx -d $DOMAIN --noninteractive --agree-tos
    chown -R 1000:1000 /etc/letsencrypt/live/$DOMAIN/
    chown -R 1000:1000 /etc/letsencrypt/archive/$DOMAIN/
    chmod -R 644 /etc/letsencrypt/live/$DOMAIN/
    chmod -R 644 /etc/letsencrypt/archive/$DOMAIN/
fi

# Start crond in background
crond -l 2 -b

# Start nginx in foreground
nginx
