require_relative '../lib/api/tvdb_manager'

describe Episodes::TvdbManager do
  describe '#exists?' do
    it 'returns episode when episode exists' do
      manager = Episodes::TvdbManager.new('The Vampire Diaries', 'tt1405406')
      expect(manager.exists?('1', '1')).to be_instance_of(TvdbParty::Episode)
    end

    it 'returns false when episode does not exist' do
      manager = Episodes::TvdbManager.new('The Vampire Diaries', 'tt1405406')
      expect(manager.exists?('99', '99')).to be nil
    end
  end
end
