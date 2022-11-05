#!/bin/bash
systemctl start mariadb.service
#service nginx stop
#mv /var/www/html/index.html /tmp
systemctl restart httpd.service
systemctl start php-fpm.service
