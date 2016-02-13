require_relative '../lib/profile_manager'
require_relative '../lib/registry'
require_relative '../config/database_test'
require_relative '../db/repositories/user_repository'

describe Profile::Manager do
  before :all do
    require_relative '../db/migrations/create_users_table.rb'
  end

  after :all do
    require_relative '../db/migrations/drop_users_table.rb'
  end

  describe '#change_name' do
    it "changes the user's name" do
      UserRepository.create(name: 'Angelin')
      user = UserRepository.find(name: 'Angelin')

      expect(user).not_to be nil

      Profile::Manager.change_name('Angelin', 'Geleto')
      new_user = UserRepository.find(id: user.id)
      expect(new_user.name).to eq 'Geleto'
    end
  end
end
