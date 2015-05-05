FROM l3iggs/archlinux-aur
MAINTAINER l3iggs <l3iggs@live.com>

# install apache
RUN sudo pacman -S --noconfirm --needed apache
# this folder is normally created by the systemd apache service which we won't be using
RUN sudo mkdir /run/httpd

# install php
RUN sudo pacman -S --noconfirm --needed php php-apache
ADD info.php /srv/http/

# for ssl
RUN sudo pacman -S --noconfirm --needed openssl
RUN sudo sed -i 's,;extension=openssl.so,extension=openssl.so,g' /etc/php/php.ini
RUN sudo sed -i 's,#LoadModule ssl_module modules/mod_ssl.so,LoadModule ssl_module modules/mod_ssl.so,g' /etc/httpd/conf/httpd.conf
RUN sudo sed -i 's,#LoadModule socache_shmcb_module modules/mod_socache_shmcb.so,LoadModule socache_shmcb_module modules/mod_socache_shmcb.so,g' /etc/httpd/conf/httpd.conf
RUN sudo sed -i 's,#Include conf/extra/httpd-ssl.conf,Include conf/extra/httpd-ssl.conf,g' /etc/httpd/conf/httpd.conf

# generate a self-signed cert
ENV SUBJECT /C=US/ST=CA/L=CITY/O=ORGANIZATION/OU=UNIT/CN=localhost
ADD genSSLKey.sh /etc/httpd/conf/genSSLKey.sh
RUN sudo -E /etc/httpd/conf/genSSLKey.sh
RUN sudo mkdir /https
RUN sudo ln -s /etc/httpd/conf/server.crt /https/server.crt
RUN sudo ln -s /etc/httpd/conf/server.key /https/server.key
RUN sudo sed -i 's,/etc/httpd/conf/server.crt,/https/server.crt,g' /etc/httpd/conf/extra/httpd-ssl.conf
RUN sudo sed -i 's,/etc/httpd/conf/server.key,/https/server.key,g' /etc/httpd/conf/extra/httpd-ssl.conf

# setup php
RUN sudo sed -i 's,LoadModule rewrite_module modules/mod_rewrite.so,LoadModule rewrite_module modules/mod_rewrite.so\nLoadModule php5_module modules/libphp5.so,g' /etc/httpd/conf/httpd.conf
RUN sudo sed -i 's,LoadModule mpm_event_module modules/mod_mpm_event.so,LoadModule mpm_prefork_module modules/mod_mpm_prefork.so,g' /etc/httpd/conf/httpd.conf
RUN sudo sed -i '$a Include conf/extra/php5_module.conf' /etc/httpd/conf/httpd.conf
RUN sudo sed -i 's,;extension=iconv.so,extension=iconv.so,g' /etc/php/php.ini
RUN sudo sed -i 's,;extension=xmlrpc.so,extension=xmlrpc.so,g' /etc/php/php.ini
RUN sudo sed -i 's,;extension=zip.so,extension=zip.so,g' /etc/php/php.ini
RUN sudo sed -i 's,;extension=bz2.so,extension=bz2.so,g' /etc/php/php.ini
RUN sudo sed -i 's,;extension=curl.so,extension=curl.so,g' /etc/php/php.ini
RUN sudo sed -i 's,;extension=ftp.so,extension=ftp.so,g' /etc/php/php.ini

# for php-ldap
RUN sudo pacman -S --noconfirm --needed php-ldap
RUN sudo sed -i 's,;extension=ldap.so,extension=ldap.so,g' /etc/php/php.ini

# for php-gd
RUN sudo pacman -S --noconfirm --needed php-gd
RUN sudo sed -i 's,;extension=gd.so,extension=gd.so,g' /etc/php/php.ini

# for php-intl
RUN sudo pacman -S --noconfirm --needed php-intl
RUN sudo sed -i 's,;extension=intl.so,extension=intl.so,g' /etc/php/php.ini 

# for php-mcrypt
RUN sudo pacman -S --noconfirm --needed php-mcrypt
RUN sudo sed -i 's,;extension=mcrypt.so,extension=mcrypt.so,g' /etc/php/php.ini

# php speeder-upper: xcache or apcu
# php-xcache
RUN sudo pacman -S --noconfirm --needed php-xcache
RUN sudo sed -i 's,;extension=xcache.so,extension=xcache.so,g' /etc/php/conf.d/xcache.ini
RUN sudo sh -c 'echo "xcache.admin.enable_auth = Off" >> /etc/php/conf.d/xcache.ini'

# OR
# php-apcu
#RUN pacman -S --noconfirm --needed php-apcu
#remove the comment in /etc/php/conf.d/apcu.ini
#RUN sed -i 's,;zend_extension=opcache.so,zend_extension=opcache.so,g' /etc/php/php.ini

# for exif support
RUN sudo pacman -S --noconfirm --needed exiv2
RUN sudo sed -i 's,;extension=exif.so,extension=exif.so,g' /etc/php/php.ini

# for sqlite database
RUN sudo pacman -S --noconfirm --needed sqlite php-sqlite
RUN sudo sed -i 's,;extension=sqlite3.so,extension=sqlite3.so,g' /etc/php/php.ini
RUN sudo sed -i 's,;extension=pdo_sqlite.so,extension=pdo_sqlite.so,g' /etc/php/php.ini

# for mariadb (mysql) database
RUN sudo pacman -S --noconfirm --needed mariadb perl-dbd-mysql
RUN sudo sed -i 's,;extension=pdo_mysql.so,extension=pdo_mysql.so,g' /etc/php/php.ini
RUN sudo sed -i 's,;extension=mysql.so,extension=mysql.so,g' /etc/php/php.ini
RUN sudo mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
#RUN sed -i 's,mysql.trace_mode = Off,mysql.trace_mode = On,g' /etc/php/php.ini
#RUN sed -i 's,mysql.default_host =,mysql.default_host = localhost,g' /etc/php/php.ini
#RUN sed -i 's,mysql.default_user =,mysql.default_user = root,g' /etc/php/php.ini

# expose web server ports
EXPOSE 80
EXPOSE 443

# start servers
ADD startServers.sh /root/startServers.sh
ENV START_APACHE true
ENV START_MYSQL true
CMD ["/root/startServers.sh"]
