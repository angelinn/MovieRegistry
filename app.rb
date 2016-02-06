require 'sinatra'
require 'active_record'
require 'imdb'

require_relative './lib/registry'

# ActiveRecord::Base.establish_connection(
#   :adapter => 'sqlite3',
#   :database =>  'movie_registry.sqlite3.db'
# )

get '/' do
  redirect '/login'
end

get '/index' do
  erb :index, :locals => { :username => @username }
end

get '/login' do
  erb :login
end

get '/about' do
  status 404
end

post '/query' do
  query = Imdb::Search.new(params[:movie_name])
  p query.movies.size
  erb :query, :locals => { :movies => query.movies.take(10) }
end

post '/login' do
  @username = params[:username]
  redirect '/index'
end

get '/add' do
  registry = MovieRegistry.new
  m = registry.add_movie(params[:id])
  erb :added, :locals => { :movie => m }
end

