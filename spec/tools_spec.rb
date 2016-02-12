require_relative '../lib/tools/tools'
require 'date'

describe Movies::Tools do
  describe '#dateify' do
    it 'returns today\'s date on invalid one' do
      invalid_date = '2016=02=12'
      expect(Movies::Tools.dateify(invalid_date)).
        to eq Date.parse(Time.now.to_s)
    end

    it 'returns input date if valid' do
      valid_date = '2016-02-12'
      expect(Movies::Tools.dateify(valid_date).to_s).to eq valid_date
    end
  end

  describe '#idfy' do
    it 'returns correct id' do
      id = '1234567'
      expect(Movies::Tools.idfy(id)).to eq 'tt' + id
    end
  end

  describe '#titleify' do
    it 'returns title without quotes, when with quotes given' do
      title = '"Spider-Man"'
      expect(Movies::Tools.titleify(title)).to eq title[1..-2]
    end

    it 'returns title without quotes, when such given' do
      title = 'Spider-Man'
      expect(Movies::Tools.titleify(title)).to eq title
    end
  end
end
