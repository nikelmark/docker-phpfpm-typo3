#!/bin/bash

DOCUMENT_ROOT=/data/web/releases/current/Web/

chown -R www-data:www-data ${DOCUMENT_ROOT}Configuration/ ${DOCUMENT_ROOT}Data/ ${DOCUMENT_ROOT}Web/
chmod -R u+rwx,g+rwx ${DOCUMENT_ROOT}Configuration/ ${DOCUMENT_ROOT}Data/ ${DOCUMENT_ROOT}Web/




#############################
## COMMAND
#############################

if [ "$1" = 'php-fpm' ]; then
	exec php-fpm
fi

exec "$@"
