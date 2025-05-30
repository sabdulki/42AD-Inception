
echo "DB_NAME=${DB_NAME}, DB_USER=${DB_USER}, DB_USER_PASS=${DB_USER_PASS}, DB_ROOT_PASS=${DB_ROOT_PASS}"
echo "Initializing MariaDB with DB name ${DB_NAME} and user ${DB_USER}"

mkdir -p /run/mysqld #здесь создастся сокет по умолчанию
#mysqld.sock — файл, через который клиент общается с сервером, если используется соединение через сокет, а не по TCP
chown -R mysql:mysql /run/mysqld

if [ ! -d "/var/lib/mysql/mysql" ]; then # проверка чтобы не перезаписывать бд если она уже есть
    echo "Initializing database..."
    mysql_install_db --user=mysql --ldata=/var/lib/mysql
fi

#its possible to create separate .sql file with sql instructions
DB_SETUP="
USE mysql;
FLUSH PRIVILEGES;
DELETE FROM mysql.user WHERE User='';
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASS}';
CREATE DATABASE IF NOT EXISTS ${DB_NAME} CHARACTER SET utf8 COLLATE utf8_general_ci;
FLUSH PRIVILEGES;
DROP USER IF EXISTS '${DB_USER}'@'%';
CREATE USER '${DB_USER}'@'%' IDENTIFIED BY '${DB_USER_PASS}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';
FLUSH PRIVILEGES;
"

#Создается временный файл SQL-скрипта, который потом подается на выполнение серверу MariaDB.
echo "${DB_SETUP}" > /tmp/setup.sql #записывает SQL-команды в файл

if ! /usr/sbin/mysqld --user=mysql --bootstrap < /tmp/setup.sql; then
  echo "❌ Database initialization failed!"
    #   exit 1
fi
  
rm -f /tmp/setup.sql
echo "deleted /tmp/setup.sql"
exec mysqld --user=mysql --socket=/run/mysqld/mysqld.sock