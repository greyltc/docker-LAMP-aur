FROM greyltc/lamp
MAINTAINER Grey Christoforo <grey@christoforo.net>

# setup aur access for a new user "docker"
ADD https://raw.githubusercontent.com/greyltc/docker-archlinux-aur/master/add-aur.sh /usr/sbin/add-aur
RUN chmod +x /usr/sbin/add-aur
RUN add-aur docker

# from now on, you can use the following command to install a PACKAGE from the AUR:
# su docker -c 'pacaur -Syyu --noedit --noconfirm PACKAGE'
