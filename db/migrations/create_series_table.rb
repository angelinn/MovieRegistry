require_relative '../../environment'

class CreateSeriesTable < ActiveRecord::Migration

  def up
    create_table :series do |t|
      t.belongs_to :movie, index: true
      t.integer :season
      t.integer :episode
    end
    puts 'ran up method'
  end

  def down
    drop_table :series
    puts 'ran down method'
  end

end

CreateSeriesTable.migrate(ARGV[0])
