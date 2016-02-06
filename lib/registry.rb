require 'date'

require_relative 'entities/series.rb'

class MovieRegistry
  attr_reader :movies

  def initialize
    @movies = []
  end

  def add_movie(title)
    movie = Movie.new(title, 2016, Date.today)
    @movies << movie
  end

  def check_for_new
  end
end

