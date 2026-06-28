FROM debian:bullseye

RUN apt-get update && apt-get install -y mariadb-server && \
    rm -rf /var/lib/apt/lists/*

# 外部からの接続を許可する設定に変更（デフォルトは 127.0.0.1 のみ許可）
RUN sed -i 's/bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf

COPY ./entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

RUN mkdir -p /var/run/mysqld && \
    chown -R mysql:mysql /var/run/mysqld

ENTRYPOINT ["entrypoint.sh"]RUN apt update && apt upgrade -y && apt install -y mariadb-server
