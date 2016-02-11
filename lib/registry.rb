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

    return nil if series == 'true' and
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
    @user.movies.last(5)
  end

  private
  def add_user(name)
    user = User.find_by(name: name) || User.create(name: name)
  end

  def add(movie, at, series, season=nil, episode=nil)
    entity = Movie.find_by(imdb_id: idfy(movie.id)) ||
      create_movie(movie, at)

    create_series(season, episode, entity) if series == 'true'

    movie
  end

  def create_movie(movie, seen_at)
    title = movie.title.include?('"') ? movie.title[1..-2] : movie.title

    Movie.create(title: title, year: movie.year,
                 user: @user, seen_at: seen_at.to_s, imdb_id: idfy(movie.id))
  end

  def create_series(season, episode, movie)
    Episode.create(season: season, episode: episode, movie: movie)
  end

  def episode_exists?(title, id, season, number)
    Episodes::Manager.new(title, id).exists?(season, number)
  end

  def idfy(id)
    "tt#{id}"
  end
end

