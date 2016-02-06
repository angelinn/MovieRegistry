require 'date'
require 'imdb'

require_relative 'entities/series.rb'

class MovieRegistry
  attr_reader :movies

  def initialize
    @movies = []
  end

  def add_movie(id)
    movie = Imdb::Movie.new(id)

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

