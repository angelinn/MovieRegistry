require 'date'

require_relative 'imdb_manager'
require_relative '../environment'

class MovieRegistry
  attr_reader :name

  def initialize(name)
    @user = add_user(name)
  end

  def add_user(name)
    user = User.where(name: name).first || User.create(name: name)
  end

  def add(id, series=false, seen_at=nil, season=nil, episode=nil)
    movie = MovieDb::ImdbManager.get_by_id(id)
    seen_at = seen_at != '' ? Date.parse(seen_at) : Date.parse(Time.now.to_s)

    entity = Movie.create(title: movie.title[1..-2], year: movie.year, user: @user, seen_at: seen_at.to_s, imdb_id: id)
    Serie.create(season: season, episode: episode, movie: entity) if series
    movie
  end

  def check_for_new
    []
  end

  def latest
    Movie.where(user: @user).last(5)
  end
end

