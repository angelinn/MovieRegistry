require_relative '../db/repositories/record_repository'
require_relative '../db/repositories/episode_repository'
require_relative '../db/repositories/movie_repository'
require_relative '../db/repositories/user_repository'
require_relative 'tools/tools'

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
      last_episode = serie.select { |s| s.episode.season == last_season }.
        max_by { |r| r.episode.episode }.episode.episode

      p EpisodeRepository.all
      EpisodeRepository.find(season: last_season, episode: last_episode)
    end

    def self.create_movie(movie, seen_at, series)
      title = Movies::Tools.titleify(movie.title)
      id = Movies::Tools.idfy(movie.id)

      MovieRepository.find(imdb_id: Movies::Tools.idfy(movie.id)) ||
        MovieRepository.create(title: title, year: movie.year, imdb_id: id)
    end

    def self.create_episode(season, episode)
      EpisodeRepository.find(season: season, episode: episode) ||
        EpisodeRepository.create(season: season, episode: episode)
    end

    def self.create_record(user, movie, seen_at, episode=nil)
      at = Movies::Tools.dateify(seen_at).to_s
      id = episode ? episode.id : nil

      find_arg = Hash[:user_id, user.id, :movie_id, movie.id, :episode_id, id]
      create_arg = Hash[:user, user, :movie, movie, :episode, episode,
                        :is_series, !!episode, :seen_at, at]

      RecordRepository.find(find_arg) || RecordRepository.create(create_arg)
    end
  end
end
