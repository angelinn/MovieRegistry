require 'httparty'

module Subtitles
  class Manager
    BASE = "http://subsunacs.net/search.php"
    def get_subtitles(title, season, episode, name)
      title.gsub!(' ', '_')
      name.gsub!(' ', '_')

      url = BASE % [title: title, season: season, episode: episode, name: name]
      puts url
      r = HTTParty.post(url, :body => { 'm' => 'the+vampire+diaries', 'l' => '0', 't' => 'Submit', 'action' => '=+++%D2%FA%F0%F1%E8+++'}, :headers => { "Referer" => 'http://subsunacs.net/', 'Content-Type': 'application/x-www-form-urlencoded' })

    end
  end
end

p Subtitles::Manager.new.get_subtitles('The Flash (2014)', '2', '12', 'Fast Lane')
