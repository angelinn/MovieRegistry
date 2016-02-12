require_relative '../../config/environment'

class DropMoviesTable < ActiveRecord::Migration
  def self.down
    drop_table :movies
    puts 'ran down method'
  end

end

DropMoviesTable.down
