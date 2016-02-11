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
    seen_at = seen_at != '' ? Date.parse(seen_at) : Date.parse(Time.now.to_s)

    return nil if series and
      not episode_exists?(movie.title, idfy(id), season, episode)

    add(movie, seen_at, series, season, episode)
  end

  def check_for_new
    series = @user.movies.select { |m| not m.episodes.empty? }
    series.map do |s|
      last = s.episodes.last
      Episodes::Manager.new(s.title, s.imdb_id).
        check_for_new(last.season, last.episode)
    end
  end

  def latest
    Hash[:movies => @user.movies.where(is_series: false).last(5),
         :episodes => Episode.last(5)]
  end

  private
  def add_user(name)
    user = User.find_by(name: name) || User.create(name: name)
  end

  def add(movie, at, series, season=nil, episode=nil)
    # Do NOT use 'or'
    entity = Movie.find_by(imdb_id: idfy(movie.id)) ||
      create_movie(movie, at, series)

    create_series(season, episode, entity) if series

    movie
  end

  def create_movie(movie, seen_at, series)
    title = movie.title.include?('"') ? movie.title[1..-2] : movie.title

    Movie.create(title: title, year: movie.year, user: @user,
                 seen_at: seen_at.to_s, imdb_id: idfy(movie.id),
                 is_series: series)
  end

  def create_series(season, episode, movie)
    Episode.find_by(season: season, episode: episode, movie_id: movie.id) ||
      Episode.create(season: season, episode: episode, movie: movie)
  end

  def episode_exists?(title, id, season, number)
    Episodes::Manager.new(title, id).exists?(season, number)
  end

  def idfy(id)
    "tt#{id}"
  end
end

