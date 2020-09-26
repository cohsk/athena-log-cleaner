# athena-log-cleaner
A port of soscleaner and shellinabox to the Cohesity Marketplace (athena) framework.  Helps scrub sensitive data from log files.

# How to use athena-log-cleaner
* Install this app on a Cohesity cluster
* Launch an instance
* Open the app webpage
* Login to the ssh session user=cleaner password=Cohe$1ty
* Switch to the root user context.  sudo -i
* Run soscleaner from the command line.  soscleaner

Example
* Create a directory /tmp/in
* Create a directory /tmp/out
* Put a test log file in /tmp/in
* Run soscleaner with the command soscleaner -f /tmp/in/test.log -o /tmp/out
* Results are in /tmp/out
* Look for a .tar.gz file
* Use tar -zxvf /tmp/out/yourfilename.tar.gz to extract the processed log file

# Author
Steve Klosky
steve.klosky@cohesity.com

# Credits
This project uses alpine linux, soscleaner and shellinabox
* https://alpinelinux.org/
* https://github.com/soscleaner/soscleaner
* https://github.com/shellinabox/shellinabox
