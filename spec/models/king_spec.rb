require 'rails_helper'

RSpec.describe King, type: :model do
  describe '.new' do
    let(:king) { FactoryBot.create :king }

    it 'is valid' do
      expect(king).to be_valid
    end

    it '#white? is true for white pieces' do
      expect(king.white?).to eq true
    end

    it '#white? is false for black pieces' do
      king.color = 'black'
      expect(king.white?).to eq false
    end

    it '#black? is true for black pieces' do
      king.color = 'black'
      expect(king.black?).to eq true
    end

    it '#black? is false for white pieces' do
      expect(king.black?).to eq false
    end

    it 'has the correct starting position' do
      expect(king.x).to eq 4
      expect(king.y).to eq 1
    end
  end
end