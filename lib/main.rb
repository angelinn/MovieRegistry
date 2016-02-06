require_relative 'registry'

class CLI

end

engine = MovieRegistry.new

p 'Hello Angie!'
p 'What movie would you like to type in?'

title = gets.chomp
engine.add_movie(title)
