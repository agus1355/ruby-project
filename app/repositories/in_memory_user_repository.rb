require 'ostruct'

class InMemoryUserRepository
  def initialize
    @users = []
    @next_id = 1
  end

  def create(username:, password_digest:, email: nil)
    user = OpenStruct.new(id: @next_id, username: username, password_digest: password_digest, email: email)
    @users << user
    @next_id += 1
    user
  end

  def find_by_username(username)
    @users.find { |u| u.username == username }
  end
end
