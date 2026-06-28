FROM debian:trixie

# 1. 必要なパッケージのインストール
# WP-CLIのダウンロード用に curl も追加する
RUN apt-get update && apt-get install -y \
    php7.4-fpm \
    php7.4-mysql \
    mariadb-client \
    wget \
    tar \
    curl \
    && rm -rf /var/lib/apt/lists/*

# 2. WordPressコアファイルのダウンロードと配置
RUN wget https://wordpress.org/latest.tar.gz \
    && tar -xzf latest.tar.gz \
    && mkdir -p /var/www/html \
    && cp -r wordpress/* /var/www/html/ \
    && rm -rf wordpress latest.tar.gz

# 3. php-fpmの設定変更（Unixソケットではなくポート9000で待機）
RUN sed -i 's|listen = /run/php/php7.4-fpm.sock|listen = 9000|g' /etc/php/7.4/fpm/pool.d/www.conf

# php-fpmの起動に必要なディレクトリを作成
RUN mkdir -p /run/php

# 4. ワーキングディレクトリの設定
WORKDIR /var/www/html

# 5. 起動スクリプトのコピーと実行権限の付与
COPY ./entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

# 6. コンテナ起動時のコマンド設定
ENTRYPOINT ["entrypoint.sh"]
CMD ["php-fpm7.4", "-F"]
