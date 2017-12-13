require 'rails_helper'

RSpec.describe Player, type: :model do
  describe '.new' do
    let(:game) {FactoryBot.create :game}
    let(:player) { FactoryBot.create :player }

    xit 'is valid' do
      player.valid? == true
      expect(player).to be_valid
    end
  end
end
