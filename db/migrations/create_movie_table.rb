require_relative '../../environment'

class CreateMovieTable < ActiveRecord::Migration

  def up
    create_table :movies do |t|
      t.belongs_to :user, index: true
      t.string  :title
      t.integer :year
      t.integer :imdb_id
      t.datetime :seen_at
    end
    puts 'ran up method'
  end

  def down
    drop_table :movies
    puts 'ran down method'
  end

end

CreateMovieTable.migrate(ARGV[0])
