require 'date'

require_relative 'imdb_manager'
require_relative '../environment'
require_relative 'episode_manager'

class MovieRegistry
  attr_reader :name

  def initialize(name)
    @user = add_user(name)
  end

  def add(id, seen_at, series, season=nil, episode=nil)
    movie = MovieDb::ImdbManager.get_by_id(id)
    seen_at = seen_at != '' ? Date.parse(seen_at) : Date.parse(Time.now.to_s)

    entity = create_movie(movie, seen_at)
    create_series(season, episode, entity) if series == 'true'

    movie
  end

  def check_for_new
    series = @user.movies.select { |m| not m.episodes.empty? }
    series.map do |s|
      last = s.episodes.last
      Episodes::Manager.new(s.title, s.imdb_id).check_for_new(last.season, last.episode)
    end
  end

  def latest
    @user.movies.last(5)
  end

  private
  def add_user(name)
    user = User.where(name: name).first || User.create(name: name)
  end

  def create_movie(movie, seen_at)
    title = movie.title.include?('"') ? movie.title[1..-2] : movie.title

    Movie.create(title: title, year: movie.year,
                 user: @user, seen_at: seen_at.to_s, imdb_id: 'tt' + movie.id)
  end

  def create_series(season, episode, movie)
    Episode.create(season: season, episode: episode, movie: movie)
  end
end

