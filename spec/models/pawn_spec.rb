require 'rails_helper'

RSpec.describe Pawn, type: :model do
  describe '.new' do
    let(:pawn) { FactoryBot.create :pawn }

    it 'is valid' do
      expect(pawn).to be_valid
    end

    it 'is white' do
      expect(pawn.color).to eq 'white'
    end

    it 'is black' do
      pawn.color = 'black'
      expect(pawn.color).to eq 'black'
    end

    it 'has the correct starting position' do
      expect(pawn.x).to eq 1
      expect(pawn.y).to eq 2
    end
  end
end