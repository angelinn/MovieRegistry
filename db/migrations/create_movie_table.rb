require_relative '../../environment'

class CreateMovieTable < ActiveRecord::Migration

  def up
    create_table :movie do |t|
      t.string  :title
      t.integer :year
      t.datetime :seen_at
    end
    puts 'ran up method'
  end

  def down
    drop_table :movie
    puts 'ran down method'
  end

end

CreateMovieTable.migrate(ARGV[0])
