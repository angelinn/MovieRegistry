require 'active_record'

Dir.glob('%s/models/*.rb' % Dir.pwd).each do |file|
  require_relative file
end

Dir.glob('%s/db/repositories/*.rb' % Dir.pwd).each do |file|
  require_relative file
end

require_relative '../db/adapters/active_record_adapter'

Repository.adapter = ActiveRecordAdapter
