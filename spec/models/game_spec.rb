require 'rails_helper'

RSpec.describe Game, type: :model do
  describe '.new' do
    let(:game) { FactoryBot.create :game }
 
    it 'is valid' do
      expect(game).to be_valid
    end
  end
end
