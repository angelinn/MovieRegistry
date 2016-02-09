require_relative '../../config/environment'

class CreateEpisodesTable < ActiveRecord::Migration

  def up
    create_table :episodes do |t|
      t.belongs_to :movie, index: true
      t.integer :season
      t.integer :episode
    end
    puts 'ran up method'
  end

  def down
    drop_table :episodes
    puts 'ran down method'
  end

end

CreateEpisodesTable.migrate(ARGV[0])
