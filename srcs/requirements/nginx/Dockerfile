FROM debian:bullseye
RUN apt-get update && \
    apt-get install -y nginx openssl && \
    rm -rf /var/lib/apt/lists/*

COPY ./nginx.conf /etc/nginx/conf.d/default.conf

# 自己署名証明書を発行する
RUN mkdir -p /etc/nginx/ssl
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/inception.key \
    -out /etc/nginx/ssl/inception.crt \
    -subj "/C=JP/ST=Tokyo/L=Inception/O=42/OU=42/CN=squinn.42.fr/UID=login"

CMD ["nginx", "-g", "daemon off;"]
