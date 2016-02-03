class Movie
  attr_reader :title, :year, :seen_at

  def initialize(title, year, seen_at)
    @title = title
    @year = year
    @seen_at = seen_at
  end
end

