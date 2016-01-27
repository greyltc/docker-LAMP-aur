FROM greyltc/lamp
MAINTAINER Grey Christoforo <grey@christoforo.net>

# setup aur access for a new user "docker"
ADD https://raw.githubusercontent.com/greyltc/docker-archlinux-aur/master/add-aur.sh /usr/sbin/add-aur
RUN chmod +x /usr/sbin/add-aur
RUN add-aur docker
