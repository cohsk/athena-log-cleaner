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

# add bash shell, git, nano, sudo, python2, openssh client
RUN apk add --no-cache --virtual bash git nano sudo python2 openssh-client

# load pip2
RUN python -m ensurepip --default-pip

# pull down and install soscleaner
RUN pip install soscleaner

# add shellinabox
RUN apk add --no-cache shellinabox --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted

# refresh apk repos and get latest
RUN apk -U upgrade && rm -rf /var/cache/apk/*

# add a linux user with a password
RUN adduser -D cleaner
RUN echo -e 'Cohe$1ty\nCohe$1ty' | passwd cleaner
RUN echo '%wheel ALL=(ALL) ALL' > /etc/sudoers.d/wheel

USER cleaner

# start shellinaboxd in the background each time the container starts, don't use https
CMD /usr/bin/shellinaboxd -t