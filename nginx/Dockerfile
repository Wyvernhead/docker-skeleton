FROM nginx:alpine

COPY nginx.conf /etc/nginx/

RUN apk update \
    && apk upgrade \
    && apk --update add logrotate \
    && apk add --no-cache openssl \
    && apk add --no-cache bash \
    && apk add --no-cache curl \
    && apk add --no-cache certbot certbot-nginx

ARG DOMAIN=localhost

RUN if [ ! $DOMAIN = localhost ]; then \
    apk add --no-cache certbot certbot-nginx && \
    certbot register --noninteractive --register-unsafely-without-email --agree-tos && \
    crontab -l | { cat; echo "38 */12 * * * certbot renew --quiet --allow-subset-of-names"; } | crontab - \
    ;fi

ARG UID=1000
ARG GID=1000

ENV UID=$UID
ENV GID=$GID

ARG PHP_UPSTREAM_CONTAINER=php-fpm
ARG PHP_UPSTREAM_PORT=9000

# Create 'messages' file used from 'logrotate'
RUN touch /var/log/messages

# Copy 'logrotate' config file
COPY logrotate/nginx /etc/logrotate.d/

# Set upstream conf and remove the default conf
RUN echo "upstream php-upstream { server ${PHP_UPSTREAM_CONTAINER}:${PHP_UPSTREAM_PORT}; }" > /etc/nginx/conf.d/upstream.conf \
    && rm /etc/nginx/conf.d/default.conf

ADD ./startup.sh /opt/startup.sh
RUN sed -i 's/\r//g' /opt/startup.sh

CMD ["/bin/bash", "/opt/startup.sh"]

EXPOSE 80 443
