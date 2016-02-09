require 'tvdb_party'

module Episode
  class Manager
    API_KEY = '51AEE5CAE610F84E'

    def initialize(title)
      @tvdb = TvdbParty::Search.new(API_KEY)
      @series = @tvdb.get_series_by_id(@tvdb.search(title).first['seriesid'])
    end

    def all
      @tvdb.get_all_episodes(@series)
    end
  end

  class Epi
    attr_reader :name, :season, :number

    def initialize(name, season, number)
      @name = name
      @season = season
      @number = number
    end
  end
end
