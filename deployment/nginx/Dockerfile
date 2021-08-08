# Build image from nginx alpine image
FROM nginx:1.21.1-alpine

#add bash and openssl |then| clean apk cache |then| generate the test certificate and private key for nginx
RUN apk --no-cache add bash=5.1.4-r0 openssl=1.1.1k-r0;\
   rm -rf /var/cache/apk/*;\
   openssl req -x509 -nodes -days 365 -subj "/C=CA/ST=QC/O=Company, Inc./CN=mydomain.com" -addext "subjectAltName=DNS:mydomain.com" -newkey rsa:2048 -keyout /etc/ssl/private/nginx-private.key -out /etc/ssl/certs/certificate.crt;

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