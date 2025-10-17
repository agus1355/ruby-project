# Usamos una imagen oficial de Ruby
FROM ruby:3.2

# Seteamos el directorio de trabajo
WORKDIR /app

# Copiamos Gemfile y Gemfile.lock primero para aprovechar caching
COPY Gemfile Gemfile.lock ./

# Instalamos las dependencias
RUN gem install bundler && bundle install

# Copiamos el resto del proyecto
COPY . .

# Exponemos el puerto que usa Sinatra por defecto
EXPOSE 4567

# Comando por defecto para correr la app
CMD ["ruby", "main.rb"]
