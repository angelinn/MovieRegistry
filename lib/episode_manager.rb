require 'httparty'

module Episode
  class Manager
    API_URL = 'http://imdbapi.poromenos.org/json/?name=%s'

    def all(title)
      response = HTTParty.get(API_URL % title)
      parsed = JSON.parse(response.body)

      @episodes = parsed[parsed.keys.first]['episodes']
      @episodes.map! { |ep| Epi.new(ep['name'], ep['season'], ep['number']) }
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
