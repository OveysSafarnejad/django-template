
server {
    listen ${LISTEN_PORT};

    location /static {
        alias /home/app/static;
    }

    location / {
        uwsgi_pass              ${APP_HOST}:${APP_PORT};
        include                 /etc/nginx/uwsgi_params;
        client_max_body_size    ${CLIENT_MAX_BODY}M;
    }
}