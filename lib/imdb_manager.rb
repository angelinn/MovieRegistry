require 'imdb'

module MovieDb
  class ImdbManager
    def self.get_by_id(id)
      Imdb::Movie.new(id)
    end

    def self.get_by_name(name)
      Imdb::Search.new(name)
    end
  end
end
