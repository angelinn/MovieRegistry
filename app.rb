require 'sinatra'
require 'active_record'

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database =>  'movie_registry.sqlite3.db'
)

get '/:name' do
  "Hello #{params[:name]}!"
end
