require 'date'

require_relative 'imdb_manager'
require_relative '../environment'

class MovieRegistry
  attr_reader :name

  def initialize(name)
    @user = add_user(name)
  end

  def add_user(name)
    user = User.where(name: name).size > 0 || User.create(name: name)
  end

  def add(id)
    movie = MovieDb::ImdbManager.get_by_id(id)

    entity = Movie.create(title: movie.title[1..-2], year: movie.year, user: @user)

    movie
  end

  def check_for_new
  end

  def latest
    Movie.all
  end

  def is_series?(movie)
    movie.title.include?('TV Series')
  end
end

