# Use this Dockerfile to build the container for athena-log-cleaner
# project details are here -- https://github.com/cohsk/athena-log-cleaner

# remember shellinabox exposes the web server on port 4200.  Remember to expose
# this port when running the dockerfile commands
#
# do something like -- docker build . --tag athena-log-cleaner
# then -- docker run -dit -p 4200:4200 athena-log-cleaner
# then later -- docker save athena-log-cleaner -o athena-log-cleaner

#use an alpine container
FROM alpine:latest

# Let docker know we'll listen on 4200
EXPOSE 4200

# refresh apk repos and get latest
RUN apk update
RUN apk upgrade

# add bash shell, git tools, nano, sudo, python3, pip3
RUN apk add bash git nano sudo python3 py-pip

apk add --update --no-cache icu-dev


# pull down and install sos
RUN pip install git+https://github.com/sosreport/sos.git#egg=sos

# addd openssh client
RUN apk add --no-cache openssh-client

# add shellinabox
RUN apk add --no-cache shellinabox --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted

# add a linux user with a password
RUN adduser -D cleaner
RUN echo -e 'Cohe$1ty\nCohe$1ty' | passwd cleaner
RUN echo '%wheel ALL=(ALL) ALL' > /etc/sudoers.d/wheel 
RUN adduser cleaner wheel

# start shellinaboxd in the background each time the container starts, don't use https
CMD /usr/bin/shellinaboxd -t