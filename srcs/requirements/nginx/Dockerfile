FROM debian:bullseye
RUN apt-get update && apt-get install -y nginx
COPY ./nginx.conf /etc/nginx/conf.d/default.conf
CMD ["nginx", "-g", "daemon off;"]
