require 'sinatra'
require 'active_record'
require 'imdb'

# ActiveRecord::Base.establish_connection(
#   :adapter => 'sqlite3',
#   :database =>  'movie_registry.sqlite3.db'
# )

get '/' do
  redirect '/login'
end

get '/index' do
  erb :index
end

get '/login' do
  erb :login
end

get '/about' do
  status 404
end

post '/movie' do
  query = Imdb::Search.new(params[:movie_name])
  p query.movies.size
  erb :query, :locals => { :movies => query.movies.take(10) }
end

post '/login' do
  @username = params[:username]
  redirect '/index'
end
