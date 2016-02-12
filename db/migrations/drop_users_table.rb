
require_relative '../../config/environment'

class DropUsersTable < ActiveRecord::Migration
  def self.down
    drop_table :users
  end
end

DropUsersTable.down
