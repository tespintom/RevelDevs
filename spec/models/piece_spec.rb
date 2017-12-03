require 'rails_helper'

RSpec.describe Piece, type: :model do
  describe '.new' do
    let(:piece) { FactoryBot.create :piece }

    it 'is valid' do
      expect(piece).to be_valid
    end
  end
end
