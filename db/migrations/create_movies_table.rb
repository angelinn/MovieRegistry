require_relative '../../config/environment'

class CreateMovieTable < ActiveRecord::Migration

  def up
    create_table :movies do |t|
      t.string  :title
      t.integer :year
      t.string  :imdb_id
    end
    puts 'ran up method'
  end

  def down
    drop_table :movies
    puts 'ran down method'
  end

end

CreateMovieTable.migrate(ARGV[0])
