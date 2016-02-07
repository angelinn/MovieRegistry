require 'date'

require_relative './imdb_manager'
require_relative 'entities/series.rb'

class MovieRegistry
  @@movies = {}
  attr_reader :name

  def initialize(name)
    @name = name
    @@movies[:name] = []
  end

  def add(id)
    movie = MovieDb::ImdbManager.get_by_id(id)

    entity = is_series?(movie) ? Series.new : Movie.new(movie, Time.now)
    @@movies[:name] << entity

    movie
  end

  def check_for_new
  end

  def latest
    @@movies[:name].take(5)
  end

  def is_series?(movie)
    movie.title.include?('TV Series')
  end
end

