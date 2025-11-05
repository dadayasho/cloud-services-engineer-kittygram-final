#!/bin/sh

# Ожидаем, пока база станет доступна
echo "Waiting for database at $DB_HOST:$DB_PORT..."
until pg_isready -h "$DB_HOST" -p "$DB_PORT"; do
  echo "Database is unavailable - sleeping"
  sleep 3
done

# Запускаем миграции
echo "Database is up - running migrations"
python3 manage.py migrate

# Запускаем сервер Django
echo "Starting Django server"
exec python3 manage.py runserver 0.0.0.0:8000
#!/bin/sh

# Ожидаем, пока база станет доступна
echo "Waiting for database at $DB_HOST:$DB_PORT..."
until pg_isready -h "$DB_HOST" -p "$DB_PORT"; do
  echo "Database is unavailable - sleeping"
  sleep 3
done

# Запускаем миграции
echo "Database is up - running migrations"
python3 manage.py migrate

# Запускаем сервер Django
echo "Starting Django server"
exec python3 manage.py runserver 0.0.0.0:8000
