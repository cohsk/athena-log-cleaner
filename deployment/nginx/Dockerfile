# Build image from nginx alpine image
FROM nginx:1.21.1-alpine

#add bash
RUN apk add bash

# refresh apk repos and get latest
RUN apk -U upgrade && rm -rf /var/cache/apk/*

#copy ssl certificate
COPY ./certificate.crt /etc/ssl/certs/

#copy ssl private key
COPY ./nginx-private.key /etc/ssl/private/

# copy nginx conf
COPY ./nginx.conf /etc/nginx/

# create permission group and user
RUN addgroup -S cohesity && adduser -S cohesity -G cohesity

# assign permission
RUN chmod -R 777 /usr/share/nginx /etc/nginx/ /etc/ssl /var/cache/nginx /var/run /var/log/nginx;  \
    sed -i 's/listen\(.*\)443;/listen 8443;/' /etc/nginx/conf.d/default.conf;

# ownership change
RUN chown -R cohesity:cohesity /usr/share/nginx

USER cohesity

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]