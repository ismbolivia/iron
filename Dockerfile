# Usa la imagen oficial de Ruby como base
FROM ruby:2.7.8

# Instala dependencias del sistema
# - build-essential: para compilar gemas con extensiones nativas
# - libpq-dev: para la gema 'pg' de PostgreSQL
# - nodejs & yarn: para webpacker y dependencias de JavaScript
# - imagemagick: para la gema 'mini_magick'
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends apt-transport-https curl bash && \
    curl -sL https://deb.nodesource.com/setup_16.x | bash - && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list && \
    apt-get update -qq && \
    apt-get install -y --no-install-recommends build-essential libpq-dev nodejs yarn imagemagick postgresql-client

# Establece el directorio de trabajo en el contenedor
WORKDIR /app

# Copia e instala las gemas de Ruby para aprovechar el cacheo de capas de Docker
COPY Gemfile Gemfile.lock ./
RUN gem install bundler:2.2.5
RUN bundle install

# Copia e instala las dependencias de JavaScript
COPY package.json yarn.lock ./
RUN yarn install

# Copia el resto del código de la aplicación al contenedor
COPY . .

# Expone el puerto 3000 para que el servidor de Rails sea accesible
EXPOSE 3000

# Configura el punto de entrada para la configuración de la base de datos
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# El comando principal para iniciar el servidor de Rails
CMD ["rails", "server", "-b", "0.0.0.0"]