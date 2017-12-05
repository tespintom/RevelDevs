require 'rails_helper'

RSpec.describe Player, type: :model do
  describe '.new' do
    let(:player) { FactoryBot.create :player }

    it 'is valid' do
      player.valid? == true
      expect(player).to be_valid
    end
  end
end
