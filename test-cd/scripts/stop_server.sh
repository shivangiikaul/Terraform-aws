
#!/bin/bash
isExistApp=pgrep httpd
if [[ -n  ]]; then
systemctl stop httpd.service
fi
isExistApp=pgrep mysqld
if [[ -n  ]]; then
systemctl stop mariadb.service
fi
isExistApp=pgrep php-fpm
if [[ -n  ]]; then
systemctl stop php-fpm.service

fi
