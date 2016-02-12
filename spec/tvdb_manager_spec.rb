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

  describe '#check_for_new' do
    it 'returns nil, when there are no new episode' do
      manager = Episodes::TvdbManager.new('The 4400', 'tt0389564')
      expect(manager.check_for_new('4', '13')).to be nil
    end

    it 'returns new episodes, when there are such' do
      manager = Episodes::TvdbManager.new('The 4400', 'tt0389564')
      expect(manager.check_for_new('4', '11')[:new_episodes].count).to be 2
    end
  end
end
