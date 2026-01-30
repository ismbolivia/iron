#!/bin/bash
set -e

# Elimina un server.pid pre-existente.
if [ -f /app/tmp/pids/server.pid ]; then
  rm /app/tmp/pids/server.pid
fi

# Crea la base de datos y ejecuta las migraciones
# El comando db:prepare hace ambas cosas: crea la BD si no existe y corre migraciones.
echo "Preparando base de datos..."
bundle exec rake db:create db:migrate

# Ejecuta el comando principal del contenedor (el que se pasa a 'docker run')
# En nuestro caso, será 'rails server -b 0.0.0.0'
exec "$@"
