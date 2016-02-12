require 'rake'

require 'sinatra'
require_relative '../lib/registry'


describe MovieRegistry do
  before :all do
    Rake::Task.define_task(:'db:create')
    Rake::Task.define_task(:'db:drop')
  end

  before :each do
    Rake::Task['db:create'].invoke
  end

  after :each do
    Rake::Task['db:drop'].invoke
  end

  describe '#add_user' do
    it 'adds user to the database' do

      name = 'Angelin'
      MovieRegistry.new(name)

      expect(User.find_by(name: name).name).to eq name
    end

    it 'does not add second user with the same name' do
      name = 'Angelin'
      MovieRegistry.new(name)
      MovieRegistry.new(name)
      expect(User.where(name: name).count).to be 1
    end
  end
end
