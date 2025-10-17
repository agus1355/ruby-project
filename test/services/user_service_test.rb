require 'minitest/autorun'
require 'minitest/mock'
require 'bcrypt'
require 'jwt'
require 'ostruct'
require_relative '../../app/services/user_service'
require_relative '../../app/repositories/in_memory_user_repository'
require_relative '../../app/exceptions'

class TestUserService < Minitest::Test
  def setup
    @repo = Minitest::Mock.new
    @service = UserService.new(@repo)
  end

  def test_create_user
    @repo.expect(:find_by_username, nil, ['test'])
    @repo.expect(:create, OpenStruct.new(id: 1, username: 'test')) { |args| args.is_a?(Hash) }
    user = @service.create_user('test', 'password')
    assert_equal 1, user[:id]
    @repo.verify
  end

  def test_login_success
    password_digest = BCrypt::Password.create('password')
    user = OpenStruct.new(id: 1, username: 'test', password_digest: password_digest)
    @repo.expect(:find_by_username, user, ['test'])
    token = @service.login('test', 'password')
    assert token
    decoded_token = JWT.decode(token, ENV['JWT_SECRET'] || 'my$ecretK3y', true, { algorithm: 'HS256' })
    assert_equal 1, decoded_token[0]['user_id']
    @repo.verify
  end

  def test_login_user_not_found
    @repo.expect(:find_by_username, nil, ['test'])
    assert_raises(UserNotFoundError) { @service.login('test', 'password') }
    @repo.verify
  end

  def test_login_invalid_credentials
    password_digest = BCrypt::Password.create('password')
    user = OpenStruct.new(id: 1, username: 'test', password_digest: password_digest)
    @repo.expect(:find_by_username, user, ['test'])
    assert_raises(InvalidCredentialsError) { @service.login('test', 'wrong_password') }
    @repo.verify
  end
end