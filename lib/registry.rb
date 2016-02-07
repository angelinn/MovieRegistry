require 'date'

require_relative 'imdb_manager'
require_relative '../environment'

class MovieRegistry
  attr_reader :name

  def initialize(name)
    @name = name
    add_user(name)
  end

  def add_user(name)
    user = User.new
    user.name = name
    user.save!
  end

  def add(id)
    movie = MovieDb::ImdbManager.get_by_id(id)

    entity = is_series?(movie) ? Series.new : Movie.new
    entity.title = movie.title
    entity.year = movie.year
    entity.save!

    movie
  end

  def check_for_new
  end

  def latest
    Movie.all.take(5)
  end

  def is_series?(movie)
    movie.title.include?('TV Series')
  end
end

