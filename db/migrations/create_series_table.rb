require_relative '../../environment'

class CreateSeriesTable < ActiveRecord::Migration

  def up
    create_table :series do |t|
      t.string  :title
      t.integer :year
      t.integer :season
      t.integer :episode
      t.datetime :seen_at
    end
    puts 'ran up method'
  end

  def down
    drop_table :series
    puts 'ran down method'
  end

end

CreateSeriesTable.migrate(ARGV[0])
