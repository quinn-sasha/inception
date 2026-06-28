#!/bin/bash

# エラーが発生したら即座にスクリプトを終了する
set -e

# WordPressのディレクトリに移動
cd /var/www/html

# wp-config.phpが存在しない場合のみ（初回起動時のみ）インストール処理を行う
if [ ! -f wp-config.php ]; then
  echo "WordPress is not installed yet. Starting configuration..."

  # 1. WP-CLI（コマンドラインツール）のダウンロードと配置
  curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
  chmod +x wp-cli.phar
  mv wp-cli.phar /usr/local/bin/wp

  # 2. MariaDBが起動して通信できるようになるまで待機
  # （これがないと、DB作成前にWordPressがDBに接続しようとしてエラーになる）
  echo "Waiting for MariaDB..."
  while ! mariadb -h"$WP_DATABASE_HOST" -u"$WP_DATABASE_USER" -p"$WP_DATABASE_PASSWORD" -e "SELECT 1;" >/dev/null 2>&1; do
    sleep 2
  done
  echo "MariaDB is ready!"

  # 3. WordPressのコアファイルをダウンロード（Dockerfileでやっていない場合）
  wp core download --allow-root

  # 4. wp-config.php の作成（docker-compose.ymlから渡された環境変数を使用）
  wp config create \
    --dbname="$WP_DATABASE_NAME" \
    --dbuser="$WP_DATABASE_USER" \
    --dbpass="$WP_DATABASE_PASSWORD" \
    --dbhost="$WP_DATABASE_HOST" \
    --allow-root

  # 5. WordPressの初期インストールと管理者アカウントの作成
  wp core install \
    --url="$DOMAIN_NAME" \
    --title="My WordPress Site" \
    --admin_user="$WP_ADMIN_USER" \
    --admin_password="$WP_ADMIN_PASSWORD" \
    --admin_email="$WP_ADMIN_EMAIL" \
    --allow-root

  # 6. 一般ユーザー（authorなどの権限）の作成
  wp user create \
    "$WP_USER_NAME" \
    "$WP_USER_EMAIL" \
    --role=author \
    --user_pass="$WP_USER_PASSWORD" \
    --allow-root

  echo "WordPress initial setup completed successfully."
else
  echo "WordPress is already configured."
fi

# 7. プロセスのすり替え（DockerfileのCMDで指定された 'php-fpm7.4 -F' をPID 1として実行）
echo "Starting PHP-FPM..."
exec "$@"
