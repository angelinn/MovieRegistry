require 'rake'

require 'sinatra'
require_relative '../lib/registry'
require_relative '../lib/episode_manager'

ActiveRecord::Base.establish_connection(
  :adapter  => 'sqlite3',
  :database => 'movie_registry_test.db'
)

describe MovieRegistry do

  before :all do
    require_relative '../db/migrations/create_users_table.rb'
    require_relative '../db/migrations/create_movies_table.rb'
    require_relative '../db/migrations/create_episodes_table.rb'
    require_relative '../db/migrations/create_records_table.rb'
  end

  after :all do
    system('rm ./movie_registry_test.db')
  end

  before :each do
    allow_any_instance_of(Episodes::TvdbManager).
      to receive(:exists?).
      and_return(true)


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

  describe '#add_movie' do
    it 'adds movie and record' do
      registry = MovieRegistry.new('Angelin')
      registry.add_movie('0413300', '2016-02-12', false)

      id = Movie.find_by(title: 'Spider-Man 3').id rescue nil
      expect(id).not_to be nil

      record = Record.find_by(movie_id: id)
      expect(record).not_to be nil

      expect(record.seen_at).to eq '2016-02-12'
      expect(record.is_series).to be false
      expect(record.movie.title).to eq 'Spider-Man 3'
      expect(record.episode).to be nil
      expect(record.user.name).to eq 'Angelin'
    end

    it 'does not duplicate movie' do
      registry = MovieRegistry.new('Angelin')
      registry.add_movie('0413300', '2016-02-12', false)
      registry.add_movie('0413300', '2016-02-12', false)

      expect(Movie.where(title: 'Spider-Man 3').count).to be 1
    end
  end

  describe '#check_for_new' do
    it 'returns false when there are no new' do
      registry = MovieRegistry.new('Angelin')
      registry.add_movie('0389564', '2016-02-12', true, 4, 13)

      allow_any_instance_of(Episodes::TvdbManager).
        to receive(:check_for_new).
        and_return(false)

      expect(registry.check_for_new.count).to be 1
      expect(registry.check_for_new.first).to be false
    end

    it 'returns episodes when there are new ones' do
      registry = MovieRegistry.new('Angelin')
      registry.add_movie('0389564', '2016-02-12', true, 4, 11)

      allow_any_instance_of(Episodes::TvdbManager).
        to receive(:check_for_new).
        and_return(true)

      expect(registry.check_for_new.count).to be 1
      expect(registry.check_for_new.first).to be true
    end
  end
end
