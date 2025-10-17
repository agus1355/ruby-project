require 'minitest/autorun'
require 'minitest/mock'
require_relative '../../app/controllers/users_controller'

class TestUsersController < Minitest::Test
  def setup
    @service = Minitest::Mock.new
    @controller = UsersController.new(@service)
  end

  def test_register_success
    @service.expect(:create_user, { id: 1, username: 'test' }, ['test', 'password'])
    result = @controller.register({ username: 'test', password: 'password' })
    assert_equal({ success: true, user: { id: 1, username: 'test' } }, result)
    @service.verify
  end

  def test_register_failure
    @service.expect(:create_user, nil) { raise "Username already taken" }
    result = @controller.register({ username: 'test', password: 'password' })
    assert_equal({ success: false, error: "Username already taken" }, result)
    @service.verify
  end

  def test_login_success
    @service.expect(:login, 'test_token', ['test', 'password'])
    result = @controller.login({ username: 'test', password: 'password' })
    assert_equal({ success: true, token: 'test_token' }, result)
    @service.verify
  end

  def test_login_failure
    @service.expect(:login, nil) { raise "Invalid credentials" }
    result = @controller.login({ username: 'test', password: 'password' })
    assert_equal({ success: false, error: "Invalid credentials" }, result)
    @service.verify
  end
end