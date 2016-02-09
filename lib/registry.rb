require 'date'

require_relative 'imdb_manager'
require_relative '../environment'

class MovieRegistry
  attr_reader :name

  def initialize(name)
    @user = add_user(name)
  end

  def add(id, seen_at, series=false, season=nil, episode=nil)
    movie = MovieDb::ImdbManager.get_by_id(id)
    seen_at = seen_at != '' ? Date.parse(seen_at) : Date.parse(Time.now.to_s)

    entity = create_movie(movie, seen_at)
    create_series(season, episode, entity) if series

    movie
  end

  def check_for_new
    []
  end

  def latest
    @user.movies.last(5)
  end

  private
  def add_user(name)
    user = User.where(name: name).first || User.create(name: name)
  end

  def create_movie(movie, seen_at)
    title = movie.title.include?('"') ? movie.title[1..-2] : movie.title

    Movie.create(title: title, year: movie.year,
                 user: @user, seen_at: seen_at.to_s, imdb_id: movie.id)
  end

  def create_series(season, episode, movie)
    Serie.create(season: season, episode: episode, movie: movie)
  end
end

