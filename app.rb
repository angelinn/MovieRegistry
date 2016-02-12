require 'sinatra'
require 'sinatra/cookies'

require_relative './config/environment'
require_relative './lib/imdb_manager'
require_relative './lib/registry'

ActiveRecord::Base.establish_connection(
  :adapter  => 'sqlite3',
  :database => 'movie_registry.db'
)

not_found do
  status 404
  erb :'shared/oops', :layout => false
end
