require_relative '../../config/environment'

class CreateRecordTable < ActiveRecord::Migration

  def up
    create_table :records do |t|
      t.belongs_to :user, index: true
      t.belongs_to :movie, index: true
      t.belongs_to :episode, index: true
      t.string :seen_at
      t.boolean :is_series
    end
    puts 'ran up method'
  end
end

CreateRecordTable.up
