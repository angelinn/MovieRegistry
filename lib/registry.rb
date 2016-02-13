require 'date'

require_relative '../config/environment'
require_relative '../lib/record_manager'
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
        movie = values.first.movie
        last = Records::Manager.get_last_episode(@user.name, movie.title)

        Episodes::TvdbManager.new(movie.title, movie.imdb_id).
          check_for_new(last.season, last.episode)
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
      entity = Records::Manager.create_movie(movie, at, series)
      episode = Records::Manager.create_episode(season, episode) if series

      Records::Manager.create_record(@user, entity, at, episode)

      movie
    end

    def episode_exists?(title, id, season, number)
      Episodes::TvdbManager.new(title, id).exists?(season, number)
    end
  end
end
