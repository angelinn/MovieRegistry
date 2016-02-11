require 'tvdb_party'
require 'date'

module Episodes
  class Manager
    API_KEY = '51AEE5CAE610F84E'

    def initialize(title, imdb_id)
      @tvdb = TvdbParty::Search.new(API_KEY)

      local = @tvdb.search(title).select { |r| r['IMDB_ID'] == imdb_id }.first
      @series = @tvdb.get_series_by_id(local['seriesid'])
    end

    def check_for_new(last_season, last_number)
      @episodes = all
      return nil if has_finished?(last_season, last_number)

      @episodes
      current = @episodes.select { |e| e.season_number == last_season.to_s and e.number == last_number.to_s }.first

      Hash[:title => @series.name, :new_episodes =>
          @episodes.select { |e| e.air_date and e.air_date > current.air_date and e.air_date < Date.parse(Time.new.to_s) }
      ]
    end

    def exists?(season, number)
      all.select { |e| e.season_number == season and e.number == number }.first
    end

    private
    def all
      @tvdb.get_all_episodes(@series)
    end

    def has_finished?(season, number)
      @episodes.sort { |a, b| a.season_number <=> b.season_number }.last.number == number.to_s
    end
  end
end
