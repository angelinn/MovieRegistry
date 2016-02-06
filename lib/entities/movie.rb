class Movie
  attr_reader :title, :year, :seen_at

  def initialize(imdb_movie, seen_at)
    @title = imdb_movie.title
    @year = imdb_movie.year
    @seen_at = seen_at
  end
end

