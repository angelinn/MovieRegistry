require 'date'

require_relative './imdb_manager'
require_relative 'entities/series.rb'

class MovieRegistry
  attr_reader :movies

  def initialize(name)
    @name = name
    @movies = []
  end

  def add_movie(id)
    movie = MovieDb::ImdbManager.get_by_id(id)

    entity = is_series?(movie) ? Series.new : Movie.new(movie, Time.now)
    @movies << entity

    movie
  end

  def check_for_new
  end

  def is_series?(movie)
    movie.title.include?('TV Series')
  end
end

