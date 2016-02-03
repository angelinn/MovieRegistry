require_relative 'series'

class MovieRegistry
  attr_reader :movies

  def initialize
    @movies = []
  end

  def add_movie(movie)
    @movies << movie
  end
end

