require 'active_record'

Dir.glob('%s/models/*.rb' % Dir.pwd).each do |file|
  require_relative file
end
