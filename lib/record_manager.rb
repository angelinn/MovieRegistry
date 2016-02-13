require_relative '../db/repositories/record_repository'
require_relative '../db/repositories/episode_repository'
require_relative '../db/repositories/movie_repository'

module Records
  class Manager
    def self.get(title, season, episode)
      movie = MovieRepository.find(title: title)

      if season and episode
        entity = EpisodeRepository.find(season: season, episode: episode)
        RecordRepository.find(movie: movie, episode: entity)
      else
        RecordRepository.find(movie: movie)
      end
    end

    def self.edit(title, seen_at, season, episode)
      record = get(title, season, episode)
      record.seen_at = seen_at
      RecordRepository.update(record)
    end
  end
end
