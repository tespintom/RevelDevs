require 'rails_helper'

RSpec.describe Piece, type: :model do
  describe '.new' do
    let(:piece) { FactoryBot.create :piece }

    it 'is valid' do
      expect(piece).to be_valid
    end
  end

  describe 'move' do
    let(:piece) { FactoryBot.create :piece }
    it '#horizontal_move? returns true if move is horizontal' do
      result = piece.horizontal_move?(1, 2, 4, 2)
      expect(result).to eq true
    end

    it '#horizontal_move? returns false if move is not horizontal' do
      result = piece.horizontal_move?(2, 5, 3, 4)
      expect(result).to eq false
    end

    xit '#vertical_move? returns true if move is vertical' do
    end

    xit '#vertical_move? returns false if move is not vertical' do
    end

    xit '#diagonal_move? returns true if move is diagonal' do
    end

    xit '#diagonal_move? returns false if move is not diagonal' do
    end

    xit '#in_bounds? returns true if the move is within bounds' do
    end

    xit '#in_bounds? returns false if the move is not within bounds' do
    end

    xit '#valid_move? returns true if the move is valid' do
    end

    xit '#valid_move? returns false if the move is not valid' do
    end
  end
end
