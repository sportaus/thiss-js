#!/bin/bash

echo "Start of start-ks.sh"

echo "Copy and parsing of files starting"

cd /dist
for f in `find . -printf '%P\n'`; do
   if [ "x$f" != "x" -a -f $f ]; then
      d=`dirname $f`
      mkdir -p /usr/share/nginx/html/$d
      envsubst '${BASE_URL} ${STORAGE_DOMAIN} ${MDQ_URL} ${SEARCH_URL} ${DEFAULT_CONTEXT} ${LOGLEVEL} ${WHITELIST}' < $f > /usr/share/nginx/html/$f
   fi
done

echo "Copy and parsing of files complete"

echo "Launching standard nginx entrypoint"

source /docker-entrypoint.sh
