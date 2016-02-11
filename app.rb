require 'sinatra'
require 'sinatra/cookies'


require_relative './lib/imdb_manager'
require_relative './lib/registry'

not_found do
  status 404
  erb :oops, :layout => false
end

get '/' do
  redirect '/login'
end

get '/index' do
  erb :index, :locals => {
    :username     => cookies[:username],
    :latest       => MovieRegistry.new(cookies[:username]).latest,
    :new_episodes => MovieRegistry.new(cookies[:username]).check_for_new
  }
end

get '/login' do
  erb :login
end

get '/movie' do
  movie = MovieDb::ImdbManager.get_by_id(params[:id])
  erb :movie, :locals => { :movie => movie, :series => params[:series] }
end

post '/query' do
  query = MovieDb::ImdbManager.get_by_name(params[:movie_name])
  erb :query, :locals => { :movies => query.movies.take(15) }
end

post '/login' do
  cookies[:username] = params[:username]
  redirect '/index'
end

post '/add' do
  registry = MovieRegistry.new(cookies[:username])

  movie = registry.add_movie(params[:id], params[:seen_at],
                         (eval params[:series]), params[:season],
                         params[:episode])

  return redirect back unless movie
  erb :added, :locals => { :movie => movie }
end

