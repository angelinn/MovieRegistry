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

  def add(id, series=false, season=nil, episode=nil)
    movie = MovieDb::ImdbManager.get_by_id(id)

    entity = Movie.create(title: movie.title[1..-2], year: movie.year, user: @user)
    Serie.create(season: season, episode: episode, movie: entity) if series
    movie
  end

  def check_for_new
  end

  def latest
    Movie.where(user: @user).last(5)
  end
end

