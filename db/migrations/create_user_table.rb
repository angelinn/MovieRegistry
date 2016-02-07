require_relative '../../environment'

class CreateUsersTable < ActiveRecord::Migration

  def up
    create_table :users do |t|
      t.string :name
    end
    puts 'ran up method'
  end

  def down
    drop_table :users
    puts 'ran down method'
  end

end

CreateUsersTable.migrate(ARGV[0])
