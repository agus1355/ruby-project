# Métodos auxiliares
module Helpers
  JWT_SECRET = ENV['JWT_SECRET'] || 'supersecret'

  def authenticate!
    auth_header = request.env['HTTP_AUTHORIZATION']
    token = auth_header&.split(' ')&.last
    begin
      payload, = JWT.decode(token, JWT_SECRET, true, { algorithm: 'HS256' })
      # Puedes usar payload si necesitas info del usuario autenticado
    rescue
      halt 401, { error: 'Token inválido o ausente' }.to_json
    end
  end
end
