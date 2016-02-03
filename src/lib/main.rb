require_relative 'entities/engine'

class CLI

end

engine = MovieRegistry.new

m = Series.new('TVD', 2003, 9)
engine.add_movie(m)
puts engine.movies.each { |m| puts m.to_s }
