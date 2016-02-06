require 'sinatra'
require 'active_record'

# ActiveRecord::Base.establish_connection(
#   :adapter => 'sqlite3',
#   :database =>  'movie_registry.sqlite3.db'
# )

get '/' do
  erb :index
end

get '/about' do
end

post '/movie' do
  "Movie: #{params[:message]}"
end
