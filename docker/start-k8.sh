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

echo "Config UTF8 support"
cat>/etc/nginx/nginx.conf<<EOF

worker_processes  auto;

error_log  /var/log/nginx/error.log notice;
pid        /tmp/nginx.pid;


events {
    worker_connections  1024;
}


http {
    proxy_temp_path /tmp/proxy_temp;
    client_body_temp_path /tmp/client_temp;
    fastcgi_temp_path /tmp/fastcgi_temp;
    uwsgi_temp_path /tmp/uwsgi_temp;
    scgi_temp_path /tmp/scgi_temp;

    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    keepalive_timeout  65;

    #gzip  on;

    include /etc/nginx/conf.d/*.conf;

    charset utf-8;
}

EOF

echo "Config CORS header"

cat>/etc/nginx/conf.d/default.conf<<EOF
server {
    listen       8080;
    server_name  localhost;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
        add_header 'Access-Control-Allow-Origin' '*' always;
        add_header 'X-Frame-Options' "ALLOW-FROM ${AUTH_SERVER_URL}";
        add_header 'Content-Security-Policy' "frame-ancestors 'self' ${AUTH_SERVER_URL}";
        try_files \$uri \$uri/index.html \$uri.html;
    }
}
EOF

echo "Launching standard nginx entrypoint"

source /docker-entrypoint.sh
