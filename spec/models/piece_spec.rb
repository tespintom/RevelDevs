require 'rails_helper'

RSpec.describe Piece, type: :model do
  describe '.new' do
    # let!(:piece) { FactoryBot.create :piece }

    it 'is valid' do
      game = FactoryBot.create(:game)
      piece = FactoryBot.build(:piece, game_id: game.id)
      expect(piece).to be_valid
    end
  end

  describe 'move' do
    # let!(:user) { FactoryBot.create :user}
    # let!(:game) { FactoryBot.create :game }
    # let!(:piece) { FactoryBot.create :piece, game_id: game.id }
    it '#horizontal_move? returns true if move is horizontal' do
      game = FactoryBot.create(:game)
      piece = FactoryBot.build(:piece, game_id: game.id)
      result = piece.horizontal_move?(1, 2, 4, 2)
      expect(result).to eq true
    end

    it '#horizontal_move? returns false if move is not horizontal' do
      game = FactoryBot.create(:game)
      piece = FactoryBot.build(:piece, game_id: game.id)
      result = piece.horizontal_move?(2, 5, 3, 4)
      expect(result).to eq false
    end

    it '#vertical_move? returns true if move is vertical' do
      game = FactoryBot.create(:game)
      piece = FactoryBot.build(:piece, game_id: game.id)
      result = piece.vertical_move?(1, 1, 1, 3)
      expect(result).to eq true
    end

    it '#vertical_move? returns false if move is not vertical' do
      game = FactoryBot.create(:game)
      piece = FactoryBot.build(:piece, game_id: game.id)
      result = piece.vertical_move?(1, 2, 2, 2)
      expect(result).to eq false
    end

    it '#diagonal_move? returns true if move is diagonal' do
      game = FactoryBot.create(:game)
      piece = FactoryBot.build(:piece, game_id: game.id)
      result = piece.diagonal_move?(1, 2, 3, 4)
      expect(result).to eq true
    end

    it '#diagonal_move? returns false if move is not diagonal' do
      game = FactoryBot.create(:game)
      piece = FactoryBot.build(:piece, game_id: game.id)
      result = piece.diagonal_move?(1, 3, 2, 3)
      expect(result).to eq false
    end

    it '#in_bounds? returns true if the move is within bounds' do
      game = FactoryBot.create(:game)
      piece = FactoryBot.build(:piece, game_id: game.id)
      result = piece.in_bounds?(4, 7)
      expect(result).to eq true
    end

    it '#in_bounds? returns false if the move is not within bounds' do
      game = FactoryBot.create(:game)
      piece = FactoryBot.build(:piece, game_id: game.id)
      result = piece.in_bounds?(2, 9)
      expect(result).to eq false
    end

    it '#valid_move? returns true if the move is valid' do
      game = FactoryBot.create(:game)
      piece = FactoryBot.build(:piece, game_id: game.id)
      result = piece.valid_move?(1, 1, 2, 3)
      expect(result).to eq true
    end

    it '#valid_move? returns false if the move is not valid' do
      game = FactoryBot.create(:game)
      piece = FactoryBot.build(:piece, game_id: game.id)
      result = piece.valid_move?(1, 2, 9, 10)
      expect(result).to eq false
    end

    it '#is_obstructed? returns true if the move is obstructed' do
      game = FactoryBot.create(:game)
      piece = FactoryBot.build(:piece, game_id: game.id)
      piece2 = FactoryBot.build(:piece, game_id: game.id)
      piece2.update_attributes(x: 2, y: 2)
      result = piece.is_obstructed?(1, 1, 3, 3)
      expect(result).to eq true
    end

    xit '#is_obstructed? returns false if the move is not obstructed' do
      game = FactoryBot.create(:game)
      piece = FactoryBot.build(:piece, game_id: game.id)
      result = piece.is_obstructed?(2, 2, 4, 4)
      expect(result).to eq false
    end
  end
end
