require 'rails_helper'

RSpec.describe King, type: :model do
  describe '.new' do
    let(:king) { FactoryBot.create :king }

    it 'is valid' do
      expect(king).to be_valid
    end

    it 'is white' do
      expect(king.color).to eq 'white'
    end

    it 'is black' do
      king.color = 'black'
      expect(king.color).to eq 'black'
    end

    it 'has the correct starting position' do
      expect(king.x).to eq 4
      expect(king.y).to eq 1
    end
  end
end