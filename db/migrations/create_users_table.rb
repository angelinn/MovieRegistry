require_relative '../../config/environment'

class CreateUsersTable < ActiveRecord::Migration

  def up
    create_table :users do |t|
      t.string :name
    end
    puts 'ran up method'
  end
end

CreateUsersTable.up
