require 'sinatra'
require 'sinatra/cookies'

require_relative './config/environment'
require_relative './config/database'
require_relative './lib/imdb_manager'
require_relative './lib/registry'

not_found do
  status 404
  erb :'shared/oops', :layout => false
end

Dir.glob('%s/routes/*.rb' % Dir.pwd).each do |file|
  require_relative file
end
