require 'date'

require_relative '../config/environment'
require_relative 'api/imdb_manager'
require_relative 'api/tvdb_manager'
require_relative 'tools/tools'

module Movies
  class Registry
    attr_reader :name

    def initialize(name)
      @user = add_user(name)
    end

    def add_movie(id, seen_at, series, season=nil, episode=nil)
      movie = MovieDb::ImdbManager.get_by_id(id)

      imdb_id = Movies::Tools.idfy(id)
      return nil if series and
        not episode_exists?(movie.title, imdb_id, season, episode)

      add(movie, seen_at, series, season, episode)
    end

    def check_for_new
      series = @user.records.where(is_series: true)

      series.group_by { |s| s.movie_id }.map do |key, values|
        last_season = values.max_by { |r| r.episode.season }.episode.season
        last_episode = values.max_by { |r| r.episode.episode }.episode.episode

        last = values.select do |v|
          v.episode.season = last_season and v.episode.episode = last_episode
        end.first

        movie = values.first.movie

        Episodes::TvdbManager.new(movie.title, movie.imdb_id).
          check_for_new(last.episode.season, last.episode.episode)
      end
    end

    def latest
      Hash[:movies => @user.records.where(is_series: false).last(5),
           :episodes => @user.records.where(is_series: true).last(5)]
    end

    private
    def add_user(name)
      UserRepository.find(name: name) || UserRepository.create(name: name)
    end

    def add(movie, at, series, season=nil, episode=nil)
      entity = create_movie(movie, at, series)
      episode = create_episode(season, episode) if series

      create_record(entity, at, episode)

      movie
    end

    def create_movie(movie, seen_at, series)
      title = Movies::Tools.titleify(movie.title)
      id = Movies::Tools.idfy(movie.id)

      MovieRepository.find(imdb_id: Movies::Tools.idfy(movie.id)) ||
        MovieRepository.create(title: title, year: movie.year, imdb_id: id)
    end

    def create_episode(season, episode)
      EpisodeRepository.find(season: season, episode: episode) ||
        EpisodeRepository.create(season: season, episode: episode)
    end

    def create_record(movie, seen_at, episode=nil)
      at = Movies::Tools.dateify(seen_at).to_s
      id = episode ? episode.id : nil

      find_arg = Hash[:user_id, @user.id, :movie_id, movie.id, :episode_id, id]
      create_arg = Hash[:user, @user, :movie, movie, :episode, episode,
                        :is_series, !!episode, :seen_at, at]

      RecordRepository.find(find_arg) || RecordRepository.create(create_arg)
    end

    def episode_exists?(title, id, season, number)
      Episodes::TvdbManager.new(title, id).exists?(season, number)
    end
  end
end
