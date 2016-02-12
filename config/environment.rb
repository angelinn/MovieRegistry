require 'active_record'

Dir.glob('%s/routes/*.rb' % Dir.pwd).each do |file|
  require_relative file
end

Dir.glob('%s/models/*.rb' % Dir.pwd).each do |file|
  require_relative file
end
