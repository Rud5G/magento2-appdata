#!/bin/sh
set -uox pipefail

if [ "$(id -u)" = '0' ]; then
    user='www-data'
    group='www-data'
else
    user="$(id -u)"
    group="$(id -g)"
fi

if ! [ -e index.php -a -e app/bootstrap.php ]; then
    echo >&2 "Magento not found in $PWD - copying now..."
    if [ "$(ls -A)" ]; then
        echo >&2 "WARNING: $PWD is not empty - press Ctrl+C now if this is an error!"
        ( set -x; ls -A; sleep 1)
    fi
    tar --create \
        --file - \
        --one-file-system \
        --directory /usr/src/magento \
        --owner "$user" --group "$group" \
        . | tar --extract --file -
    echo >&2 "Complete! Magento has been successfully copied to $PWD"
fi

# Set the correct file permissions for Magento 2

chgrp -R 33 /var/www
chmod -R g+rs /var/www

set +x

while true;
do
  chmod -R ug+rws /var/www/html/pub/errors
  chmod -R ug+rws /var/www/html/pub/static
  chmod -R ug+rws /var/www/html/pub/media
  chmod -R ug+rws /var/www/html/app/etc
  chmod -R ug+rws /var/www/html/var
  chmod -R ug+rws /var/www/html/generated

  chmod ug+x /var/www/html/bin/magento

  sleep 10
done
