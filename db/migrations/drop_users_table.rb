
require_relative '../../config/environment'

class DropUsersTable < ActiveRecord::Migration
  def down
    drop_table :users
  end
end

CreateUsersTable.down
