
```yml

server {
    listen 80 default_server;
    server_name elk-eos.e2enetworks.net;
    server_name 172.16.11.76;
    return 301 https://elk-eos.e2enetworks.net$request_uri;
}


server {
     listen 443 ssl;
     server_name elk-eos.e2enetworks.net;
    if ($host != "elk-eos.e2enetworks.net") {
        return 301 https://elk-eos.e2enetworks.net$request_uri;
    }
    auth_basic "Restricted Access";
    auth_basic_user_file /etc/nginx/htpasswd.users;

     ssl_protocols TLSv1.2;
     ssl_certificate "/etc/nginx/ssl/star-e2e.crt";
     ssl_certificate_key "/etc/nginx/ssl/star-e2e.key";
     ssl_session_cache shared:SSL:1m;
     ssl_session_timeout  10m;
     ssl_ciphers HIGH:!aNULL:!MD5;
     location / {
         proxy_pass http://localhost:5601;
         proxy_http_version 1.1;
         proxy_set_header Upgrade $http_upgrade;
         proxy_set_header Connection 'upgrade';
         proxy_set_header Host $host;
         proxy_cache_bypass $http_upgrade;
     }
 }
```
~                     
