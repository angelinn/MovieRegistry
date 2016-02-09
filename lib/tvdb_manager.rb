require 'tvdb_party'

require_relative 'models/movie_view_model'

module MovieDb
  class TvdbManager
    API_KEY = "51AEE5CAE610F84E"

    def initialize
      @tvdb = TvdbParty::Search.new(API_KEY)
    end

    def get_by_id(id)
      @tvdb.get_series_by_id(id)
    end

    def get_by_name(name)
      @tvdb.search(name).map do |s|
        model = MovieViewModel.new.instance_eval do
          @id = s['seriesid']
          @title = s['SeriesName']
          @imdb_id = s['IMDB_ID']
          @year = Date.parse(s['FirstAired']).year rescue nil
          @poster = s['Banner']
        end
    end
  end

  class TvdbSearchResult
    attr_reader :id, :name, :imdb_id, :aired

    def initialize(id, name, imdb_id, aired, banner)
      @id = id
      @name = name
      @imdb_id = imdb_id
      @aired = Date.parse(aired)
    end

    def year
      @aired.year
    end
  end
end
