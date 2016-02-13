require_relative '../lib/registry'
require_relative '../config/database_test'
require_relative '../config/rspec'

require 'database_cleaner'

describe Movies::Registry do

  before :all do
    require_relative '../db/migrations/create_users_table.rb'
    require_relative '../db/migrations/create_movies_table.rb'
    require_relative '../db/migrations/create_episodes_table.rb'
    require_relative '../db/migrations/create_records_table.rb'

    class M < Struct.new(:title, :year, :id)
    end
  end

  after :all do
    system('rm ./movie_registry_test.db')
  end

  before :each do |example|
    allow_any_instance_of(Episodes::TvdbManager).
      to receive(:exists?).
      and_return(true)

    unless example.metadata[:skip_before]
      allow(MovieDb::ImdbManager).
        to receive(:get_by_id).
        and_return(M.new('Spider-Man 3', 2007, '0413300'))
      end
  end

  describe '#add_user' do
    it 'adds user to the database' do

      name = 'Angelin'
      Movies::Registry.new(name)

      expect(User.find_by(name: name).name).to eq name
    end

    it 'does not add second user with the same name' do
      name = 'Angelin'
      Movies::Registry.new(name)
      Movies::Registry.new(name)
      expect(User.where(name: name).count).to be 1
    end
  end

  describe '#add_movie' do
    it 'adds movie and record' do
      registry = Movies::Registry.new('Angelin')
      registry.add_movie('0413300', '2014-01-21', false)

      id = Movie.find_by(title: 'Spider-Man 3').id rescue nil
      expect(id).not_to be nil

      record = Record.find_by(movie_id: id)
      expect(record).not_to be nil

      expect(record.seen_at).to eq '2014-01-21'
      expect(record.is_series).to be false
      expect(record.movie.title).to eq 'Spider-Man 3'
      expect(record.episode).to be nil
      expect(record.user.name).to eq 'Angelin'
    end

    it 'does not duplicate movie' do
      registry = Movies::Registry.new('Angelin')
      registry.add_movie('0413300', '2016-02-12', false)
      registry.add_movie('0413300', '2016-02-12', false)

      expect(Movie.where(title: 'Spider-Man 3').count).to be 1
    end
  end

  describe '#check_for_new' do
    it 'returns false when there are no new' do
      registry = Movies::Registry.new('Angelin')
      registry.add_movie('0389564', '2016-02-12', true, 4, 13)

      allow_any_instance_of(Episodes::TvdbManager).
        to receive(:check_for_new).
        and_return(false)

      expect(registry.check_for_new.count).to be 1
      expect(registry.check_for_new.first).to be false
    end

    it 'returns episodes when there are new ones' do
      registry = Movies::Registry.new('Angelin')
      registry.add_movie('0389564', '2016-02-12', true, 4, 11)

      allow_any_instance_of(Episodes::TvdbManager).
        to receive(:check_for_new).
        and_return(true)

      expect(registry.check_for_new.count).to be 1
      expect(registry.check_for_new.first).to be true
    end
  end

  describe '#latest' do
    it 'returns latest movies in correct order', :skip_before do
      registry = Movies::Registry.new('Angelin')

      smn = M.new('Spider-Man 3', 2007, '0413300')
      inv = M.new('The Invincible', 2005, '3214034')
      exp = M.new('The Expendables 2', 2012, '0000000')

      allow(MovieDb::ImdbManager).
        to receive(:get_by_id).
        and_return(smn, inv, exp)

      registry.add_movie(nil, nil, nil)
      registry.add_movie(nil, nil, nil)
      registry.add_movie(nil, nil, nil)

      expect(registry.latest[:movies].map { |m| m.movie.title}).
        to eq [smn, inv, exp].map { |m| m.title }
    end

    it 'returns latest series in correct order', :skip_before do
      registry = Movies::Registry.new('Angelin')

      smn = M.new('4400', 2007, '0415300')
      inv = M.new('The Vampire Diaries', 2005, '3244034')
      exp = M.new('Tom and Jerry', 2012, '0100000')

      allow(MovieDb::ImdbManager).
        to receive(:get_by_id).
        and_return(smn, inv, exp)

      registry.add_movie(nil, nil, true, 1, 1)
      registry.add_movie(nil, nil, true, 1, 1)
      registry.add_movie(nil, nil, true, 1, 1)

      expect(registry.latest[:episodes].map { |m| m.movie.title }.last(3)).
        to eq [smn, inv, exp].map { |m| m.title }
    end

    it 'returns [] when there are no movies', :skip_before do
      registry = Movies::Registry.new('Angelin')
      expect(registry.latest[:movies]).to eq []
    end

    it 'returns [] when there are no episodes', :skip_before do
      registry = Movies::Registry.new('Angelin')
      expect(registry.latest[:episodes]).to eq []
    end
  end
end
