require 'sinatra'
require 'sinatra/cookies'


require_relative './lib/imdb_manager'
require_relative './lib/registry'


get '/' do
  redirect '/login'
end

get '/index' do
  erb :index, :locals => {
    :username => cookies[:username],
    :latest   => MovieRegistry.new(cookies[:username]).latest
  }
end

get '/login' do
  erb :login
end

get '/about' do
  status 404
end

post '/query' do
  query = MovieDb::ImdbManager.get_by_name(params[:movie_name])
  erb :query, :locals => { :movies => query.movies.take(10) }
end

post '/login' do
  cookies[:username] = params[:username]
  redirect '/index'
end

get '/add' do
  registry = MovieRegistry.new(cookies[:username])
  m = registry.add(params[:id])
  erb :added, :locals => { :movie => m }
end

