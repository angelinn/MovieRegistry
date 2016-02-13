require_relative '../db/repositories/record_repository'
require_relative '../db/repositories/episode_repository'
require_relative '../db/repositories/movie_repository'
require_relative '../db/repositories/user_repository'

module Records
  class Manager
    def self.get(username, title, season, episode)
      user = UserRepository.find(name: username)
      movie = MovieRepository.find(title: title)

      if season and episode
        entity = EpisodeRepository.find(season: season, episode: episode)
        RecordRepository.find(user: user, movie: movie, episode: entity)
      else
        RecordRepository.find(user: user, movie: movie)
      end
    end

    def self.edit(username, title, seen_at, season, episode)
      record = get(username, title, season, episode)
      record.seen_at = seen_at
      RecordRepository.update(record)
    end

    def self.get_last_episode(username, title)
      user = UserRepository.find(name: username)
      movie = MovieRepository.find(title: title)
      serie = RecordRepository.where(user: user, movie: movie, is_series: true)

      last_season = serie.max_by { |r| r.episode.season }.episode.season
      last_episode = serie.max_by { |r| r.episode.episode }.episode.episode

      EpisodeRepository.find(season: last_season, episode: last_episode)
    end
  end
end
