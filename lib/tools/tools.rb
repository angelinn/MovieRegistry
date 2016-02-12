module Movies
  class Tools
    def self.idfy(id)
      "tt#{id}"
    end

    def self.titleify(title)
      title.include?('"') ? title[1..-2] : title
    end

    def self.dateify(date)
      Date.parse(date) rescue Date.parse(Time.now.to_s)
    end
  end
end
