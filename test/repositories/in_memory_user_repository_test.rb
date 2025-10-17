require 'minitest/autorun'
require_relative '../../app/repositories/in_memory_user_repository'

class TestInMemoryUserRepository < Minitest::Test
  def setup
    @repo = InMemoryUserRepository.new
  end

  def test_create
    user = @repo.create(username: 'test', password_digest: 'test_digest')
    assert_equal 1, user.id
    assert_equal 'test', user.username
  end

  def test_find_by_username
    @repo.create(username: 'test', password_digest: 'test_digest')
    user = @repo.find_by_username('test')
    assert user
    assert_equal 'test', user.username
  end
end