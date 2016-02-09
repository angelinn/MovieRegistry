require 'active_record'

Dir.glob('%s/db/entities/*.rb' % Dir.pwd).each do |file|
  require_relative file
  puts 'requiring ' + file
end

ActiveRecord::Base.establish_connection(
  :adapter  => 'sqlite3',
  :database => 'movie_registry.db'
)
