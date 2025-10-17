# app/controllers/users_controller.rb
class UsersController
  def initialize(user_service)
    @service = user_service
  end

  def register(params)
    username = params[:username]
    password = params[:password]
    begin
      user = @service.create_user(username, password)
    rescue => e
      return { success: false, error: e.message }
    else
      { success: true, user: user }
    end
  end

  def login(params)
    username = params[:username]
    password = params[:password]
    begin
      token = @service.login(username, password)
    rescue => e
      return { success: false, error: e.message }
    else
      { success: true, token: token }
    end
  end
end