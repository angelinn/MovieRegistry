require_relative '../../config/environment'

class DropEpisodesTable < ActiveRecord::Migration

  def down
    drop_table :episodes
    puts 'ran down method'
  end
end

DropEpisodesTable.down
