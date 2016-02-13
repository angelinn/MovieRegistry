require 'active_record'
require_relative '../lib/record_manager'
require_relative '../config/database_test'
require_relative '../config/rspec'

require 'database_cleaner'

describe Records::Manager do
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

  describe '#create_episode' do
    it 'creates new episode' do
      old = EpisodeRepository.find(season: 1, episode: 1)
      expect(old).to be nil

      Records::Manager.create_episode(1, 1)
      expect(EpisodeRepository.find(season: 1, episode: 1)).not_to be nil
    end

    it 'returns existing episode and does not duplicate' do
      old = Records::Manager.create_episode(2, 2)
      new_episode = Records::Manager.create_episode(2, 2)

      expect(old.id).to be new_episode.id
    end
  end

  describe '#create_movie' do
    it 'creates new movie' do
      old = MovieRepository.find(title: 'Vampires')
      expect(old).to be nil

      movie = M.new('Vampires', 2012, '31231231')
      Records::Manager.create_movie(movie, '', false)
      expect(MovieRepository.find(title: 'Vampires')).not_to be nil
    end

    it 'returns existing movie and does not duplicate' do
      movie = M.new('Something', 2012, '65731231')
      old = Records::Manager.create_movie(movie, '', false)
      new_episode = Records::Manager.create_movie(movie, '', false)

      expect(old.id).to be new_episode.id
    end
  end

  describe '#create_record' do
    it 'creates new record' do
      m = M.new('Cool stuff', 2012, '36789171')
      movie = Records::Manager.create_movie(m, '', false)

      user = UserRepository.create(name: 'Pichaga')
      record = Records::Manager.create_record(user, movie, '', nil)
      queried = RecordRepository.find(id: record.id)

      expect(queried).not_to be nil
    end
  end

  describe '#edit' do
    it 'edits record' do
      user = UserRepository.create(name: 'Pichaga')
      m = M.new('Cool stuff', 2012, '36789171')
      movie = Records::Manager.create_movie(m, '', false)

      Records::Manager.create_record(user, movie, '', nil)
      Records::Manager.edit(user.name, 'Cool stuff', '2019-05-06', nil, nil)

      record = RecordRepository.find(user: user, seen_at: '2019-05-06')
      expect(record).not_to be nil
    end
  end

  describe '#get_last_episode' do
    it 'returns last episode' do
      user = UserRepository.create(name: 'Pichaga')
      m = M.new('Cool stuff', 2012, '36789171')
      movie = Records::Manager.create_movie(m, '', true)
      episode = Records::Manager.create_episode(1, 20)
      other = Records::Manager.create_episode(10, 1)

      Records::Manager.create_record(user, movie, '', episode)
      Records::Manager.create_record(user, movie, '', other)

      last = Records::Manager.get_last_episode(user.name, m.title)
      expect(last.id).to be other.id
    end
  end
end
