# app/services/user_service.rb
require 'bcrypt'
require 'jwt'

class UserService

  def initialize(user_repository)
    @repo = user_repository
  end

  # Crea un usuario y devuelve un hash con los datos públicos (sin contraseña)
  def create_user(username, password, email = nil)
    user = @repo.find_by_username(username)
    if user
      raise UsernameTakenError, 'Username already taken'
    end
    password_digest = BCrypt::Password.create(password)
    user = @repo.create(username: username, password_digest: password_digest, email: email)
    if user.nil?
      raise UserNotCreatedError, 'Error creating user'
    end

    {
      id: user.id,
      username: user.username,
      email: user.respond_to?(:email) ? user.email : nil
    }
  end

  # Devuelve un JWT si el login es exitoso, sino nil
  def login(username, password)
    user = @repo.find_by_username(username)
    if user.nil?
      raise UserNotFoundError, "Usuario no encontrado"
    end

    if BCrypt::Password.new(user.password_digest) != password
      raise InvalidCredentialsError, "Credenciales inválidas"
    end

    payload = { user_id: user.id, username: user.username, exp: (Time.now + 3600).to_i }
    secret = ENV['JWT_SECRET'] || 'my$ecretK3y'
    token = JWT.encode(payload, secret, 'HS256')
    token
  end
end