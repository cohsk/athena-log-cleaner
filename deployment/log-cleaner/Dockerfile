# Use this Dockerfile to build the container for athena-log-cleaner
# project details are here -- https://github.com/cohsk/athena-log-cleaner
# remember shellinabox exposes the web server on port 4200.  Remember to expose
# this port when running the dockerfile commands
#
# do something like -- docker build . --tag athena-log-cleaner
# then -- docker run -dit -p 4200:4200 athena-log-cleaner
# then later -- docker save athena-log-cleaner -o athena-log-cleaner

#use an alpine container
FROM alpine:3.14.0

# add bash shell, git, nano, sudo, python2, openssh client
# added shadow package to expire password and force password change

RUN apk add --no-cache bash=5.1.4-r0 git=2.32.0-r0 nano=5.7-r2 sudo=1.9.7_p1-r1 python2=2.7.18-r2 openssh-client=8.6_p1-r2 shadow=4.8.1-r0 openssl=1.1.1k-r0 && \
   python -m ensurepip --default-pip && \
   pip install --no-cache-dir "soscleaner==0.4.4" && \
   apk add --no-cache shellinabox=2.21-r1 --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted && \
   rm -rf /var/cache/apk/*

# creating cleaner user and giving sudo access
SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
RUN adduser -D cleaner \
        && echo "cleaner ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/cleaner \
        && chmod 0440 /etc/sudoers.d/cleaner && \
        cred="Cohe\$1ty" && \
        printf "%s\n%s" "$cred" "$cred"| passwd cleaner && \
        chage -d 0 cleaner

# setting container image user to non-root user
USER cleaner

#setting working directory
WORKDIR /

# start shellinaboxd; set the certificate directory to /tmp so that the proc
# can use this area to generatre a test certificate and serve https
# this will help to shift this app to https for security purposes
CMD ["sudo", "/usr/bin/shellinaboxd", "-c", "/tmp"]