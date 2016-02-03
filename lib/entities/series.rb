require_relative 'movie'

class Series < Movie
  def initialize(title, year, episode)
    super(title, year)
    @episode = episode
  end

  def to_s
    "#{@title}, #{@year}, #{@episode}"
  end
end
