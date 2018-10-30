#/bin/bash
set -e
if [ "${1#-}" != "$1" ]; then
	set -- memcached "$@"
fi
exec "$@"
