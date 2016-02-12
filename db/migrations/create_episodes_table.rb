require_relative '../../config/environment'

class CreateEpisodesTable < ActiveRecord::Migration

  def up
    create_table :episodes do |t|
      t.integer :season
      t.integer :episode
    end
    puts 'ran up method'
  end
end

CreateEpisodesTable.up
