require 'date'

require_relative 'imdb_manager'
require_relative '../config/environment'
require_relative 'episode_manager'

class MovieRegistry
  attr_reader :name

  def initialize(name)
    @user = add_user(name)
  end

  def add_movie(id, seen_at, series, season=nil, episode=nil)
    movie = MovieDb::ImdbManager.get_by_id(id)

    return nil if series and
      not episode_exists?(movie.title, idfy(id), season, episode)

    add(movie, seen_at, series, season, episode)
  end

  def check_for_new
    series = @user.records.where(is_series: true)

    series.group_by { |s| s.movie_id }.map do |key, values|
      last_season = values.max_by { |r| r.episode.season }.episode.season
      last_episode = values.max_by { |r| r.episode.episode }.episode.episode

      last = values.select { |v| v.episode.season = last_season and
          v.episode.episode = last_episode }.first

      movie = values.first.movie

      Episodes::Manager.new(movie.title, movie.imdb_id).
        check_for_new(last.episode.season, last.episode.episode)
    end
  end

  def latest
    Hash[:movies => @user.records.where(is_series: false).last(5),
         :episodes => @user.records.where(is_series: true).last(5)]
  end

  private
  def add_user(name)
    User.find_by(name: name) || User.create(name: name)
  end

  def add(movie, at, series, season=nil, episode=nil)
    entity = create_movie(movie, at, series)
    episode = create_episode(season, episode) if series

    create_record(entity, at, episode)

    movie
  end

  def create_movie(movie, seen_at, series)
    title = movie.title.include?('"') ? movie.title[1..-2] : movie.title

    Movie.find_by(imdb_id: idfy(movie.id)) ||
      Movie.create(title: title, year: movie.year, imdb_id: idfy(movie.id))
  end

  def create_episode(season, episode)
    Episode.find_by(season: season, episode: episode) ||
      Episode.create(season: season, episode: episode)
  end

  def create_record(movie, seen_at, episode=nil)
    at = Date.parse(seen_at) rescue Date.parse(Time.now.to_s)
    id = episode ? episode.id : nil

    Record.find_by(user_id: @user.id, movie_id: movie.id, episode_id: id) ||
      Record.create(user: @user, movie: movie, episode: episode, is_series: !!episode, seen_at: at.to_s)
  end

  def episode_exists?(title, id, season, number)
    Episodes::Manager.new(title, id).exists?(season, number)
  end

  def idfy(id)
    "tt#{id}"
  end
end

