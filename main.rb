# main.rb
require 'dotenv/load'
require 'sinatra'
require 'json'
require 'jwt'
require 'rufus-scheduler'
require 'logger'
require_relative 'lib/helpers'
require_relative 'app/repositories/in_memory_product_repository'
require_relative 'app/services/product_service'
require_relative 'app/controllers/products_controller'
require_relative 'app/repositories/in_memory_user_repository'
require_relative 'app/services/user_service'
require_relative 'app/controllers/users_controller'
require_relative 'app/exceptions'

set :bind, '0.0.0.0'
use Rack::Deflater
helpers Helpers

# Endpoints
before '/products*' do
  authenticate!
end

logger = Logger.new($stdout)

scheduler = Rufus::Scheduler.new
product_repo = InMemoryProductRepository.new
product_service = ProductService.new(product_repo, scheduler, logger)
product_controller = ProductController.new(product_service)

user_repo = InMemoryUserRepository.new
users_service = UserService.new(user_repo)
users_controller = UsersController.new(users_service)

get '/authors' do
  content_type 'text/plain'
  cache_control :public, max_age: 86400
  File.read('authors')
end

get '/openapi' do
  content_type 'text/yaml'
  headers 'Cache-Control' => 'no-store, no-cache, must-revalidate, max-age=0'
  File.read('openapi.yaml')
end

# Products endpoints
get '/products' do
  content_type :json
  result = product_controller.index
  if result[:success]
    status 200
    { products: result[:products] }.to_json
  else
    status 500
    { error: 'Cant get products' }.to_json
  end
end

get '/products/:id' do
  content_type :json
  result = product_controller.show(params[:id].to_i)
  if result[:success]
    status 200
    { product: result[:product] }.to_json
  else
    status 404
    { error: result[:error] }.to_json
  end
end

post '/products' do
  content_type :json
  data = JSON.parse(request.body.read, symbolize_names: true)
  result = product_controller.create(data)
  if result[:success]
    status 201
    { message: result[:message] }.to_json
  else
    status 422
    { error: result[:error] }.to_json
  end
end

# User endpoints

post '/users' do
  content_type :json
  data = JSON.parse(request.body.read, symbolize_names: true)
  result = users_controller.register(data)
  if result[:success]
    status 201
    result.to_json
  else
    status 400
    result.to_json
  end
end

post '/users/login' do
  content_type :json
  data = JSON.parse(request.body.read, symbolize_names: true)
  result = users_controller.login(data)
  if result[:success]
    status 201
    result.to_json
  else
    status 400
    result.to_json
  end
end