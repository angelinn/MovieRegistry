require_relative 'entities/series.rb'


class MovieRegistry
  attr_reader :movies

  def initialize
    @movies = []
  end

  def add_movie(title)
    @movies << movie
  end
end

