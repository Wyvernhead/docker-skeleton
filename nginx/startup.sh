#!/bin/bash

if [ -n $DOMAIN ] && [ ! $DOMAIN = localhost ] && [ ! -f /etc/letsencrypt/live/$DOMAIN/fullchain.pem ]; then
    certbot certonly --nginx -d $DOMAIN --noninteractive --agree-tos
    chmod -R 644 /etc/letsencrypt/live/$DOMAIN/
    chown -R 1000:1000 /etc/letsencrypt/live/$DOMAIN/
fi

# Start crond in background
crond -l 2 -b

# Start nginx in foreground
nginx
