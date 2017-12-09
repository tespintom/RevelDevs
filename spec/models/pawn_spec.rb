require 'rails_helper'

RSpec.describe Pawn, type: :model do
  describe '.new' do
    let(:pawn) { FactoryBot.create :pawn }

    it 'is valid' do
      expect(pawn).to be_valid
    end

    it '#white? is true for white pieces' do
      expect(pawn.white?).to eq true
    end

    it '#white? is false for black pieces' do
      pawn.color = 'black'
      expect(pawn.white?).to eq false
    end

    it '#black? is true for black pieces' do
      pawn.color = 'black'
      expect(pawn.black?).to eq true
    end

    it '#black? is false for white pieces' do
      expect(pawn.black?).to eq false
    end

    it 'has the correct starting position' do
      expect(pawn.x).to eq 1
      expect(pawn.y).to eq 2
    end
  end
end