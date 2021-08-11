# athena-log-cleaner
A port of soscleaner and shellinabox to the Cohesity Marketplace (athena) framework.  Helps scrub sensitive data from log files.
Currently experimental.

# How to use athena-log-cleaner
* Install this app on a Cohesity cluster
* Launch an instance
* Open the app webpage
* Login to the ssh session user=cleaner password=Cohe$1ty
* Note the system will ask for a new cleaner password.  Please remember/record the new password.
* Switch to the root user context.  sudo -i
* Run soscleaner from the command line.  soscleaner
* Here is a short demo.  Includes usage and submitting an issue.  https://youtu.be/Bco9QDWfb64

Example
* Create a directory /tmp/in
* Create a directory /tmp/out
* Put a test log file in /tmp/in
* Run soscleaner with the command sudo soscleaner -f /tmp/in/test.log -o /tmp/out
* Results are in /tmp/out
* Look for a .tar.gz file
* Use tar -zxvf /tmp/out/yourfilename.tar.gz to extract the processed log file

# Notes
* In the spirit of quick prototyping, extensive documentation and samples have not yet been added to this project.  The author encourages and welcomes documentation collaboration on this project.  Please contact me for details.
* The current version is somewhat rudimentary.  For feature requests, please submit using the github project's issue management system.  Programming and engineering of new features is a collaborative effort.  Please contact me for details.

# Author
Steve Klosky
steve.klosky@cohesity.com

# Credits
This project uses alpine linux, soscleaner, nginx and shellinabox
* https://alpinelinux.org/
* https://github.com/soscleaner/soscleaner
* https://github.com/shellinabox/shellinabox
* https://hub.docker.com/_/nginx
* --
* Big thanks to the Cohesity team for helping on this!
* Girish Krishnamurthy
* Rajat Gupta
* Ankur Rathi
* Balachandra Shanabhag
* OSS Team
* Navya Bharath Badisa
* Joy Chattaraj
* Mark Mullenhoff
* Billy Woods


This project uses the following alpine linux packages.  Package details are in the package database -- https://pkgs.alpinelinux.org/packages
* bash
* git
* nano
* python (python2)
* openssh-client
* shadow
* openssl
