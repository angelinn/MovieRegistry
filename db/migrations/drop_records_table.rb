require_relative '../../config/environment'

class DropRecordsTable < ActiveRecord::Migration
  def self.down
    drop_table :records
    puts 'ran down method'
  end
end

DropRecordsTable.migrate(ARGV[0])
