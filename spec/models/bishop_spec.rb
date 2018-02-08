require 'rails_helper'

RSpec.describe Bishop, type: :model do
  describe '.new' do
    it 'is valid' do
      game = FactoryBot.create(:game)
      bishop = FactoryBot.build(:bishop, game_id: game.id)
      expect(bishop).to be_valid
    end

    it '#white? is true for white pieces' do
      game = FactoryBot.create(:game)
      bishop = FactoryBot.build(:bishop, game_id: game.id)
      expect(bishop.white?).to eq true
    end

    it '#white? is false for black pieces' do
      game = FactoryBot.create(:game)
      bishop = FactoryBot.build(:bishop, game_id: game.id)
      bishop.color = 'black'
      expect(bishop.white?).to eq false
    end

    it '#black? is true for black pieces' do
      game = FactoryBot.create(:game)
      bishop = FactoryBot.build(:bishop, game_id: game.id)
      bishop.color = 'black'
      expect(bishop.black?).to eq true
    end

    it '#black? is false for white pieces' do
      game = FactoryBot.create(:game)
      bishop = FactoryBot.build(:bishop, game_id: game.id)
      expect(bishop.black?).to eq false
    end

    it 'has the correct starting position' do
      game = FactoryBot.create(:game)
      bishop = FactoryBot.build(:bishop, game_id: game.id)
      expect(bishop.x).to eq 3
      expect(bishop.y).to eq 1
    end
  end

  describe 'move validation' do
    it '#in_range returns false if horizontal move ' do
      game = FactoryBot.create(:game)
      bishop = FactoryBot.build(:bishop, game_id: game.id)
      result = bishop.send(:in_range?, 4, 1) # if method is private
      # if not private: result = bishop.in_range?(4, 1, 5, 1)
      expect(result).to eq false
    end

    it '#in_range returns false if vertical move' do
      game = FactoryBot.create(:game)
      bishop = FactoryBot.build(:bishop, game_id: game.id)
      result = bishop.send(:in_range?, 3, 2)
      expect(result).to eq false
    end

    it '#in_range returns true if diagonal move is in bishop\'s range' do
      game = FactoryBot.create(:game)
      bishop = FactoryBot.build(:bishop, game_id: game.id)
      result = bishop.send(:in_range?, 4, 2)
      expect(result).to eq true
    end

    it '#in_range returns false if move is not in bishop\'s range' do
      game = FactoryBot.create(:game)
      bishop = FactoryBot.build(:bishop, game_id: game.id)
      result = bishop.send(:in_range?, 8, 2)
      expect(result).to eq false
    end

    it '#is_move_valid? returns true if bishop\'s move is valid' do
      game = FactoryBot.create(:game)
      bishop = FactoryBot.build(:bishop, game_id: game.id)
      result = bishop.is_move_valid?(4, 2)
      expect(result).to eq true
    end

    it '#is_move_valid? returns false if bishop\'s move is off the board' do
      game = FactoryBot.create(:game)
      bishop = FactoryBot.build(:bishop, game_id: game.id)
      result = bishop.is_move_valid?(4, 0)
      expect(result).to eq false
    end

    it '#is_move_valid? returns false if bishop\'s move is out of range for bishop' do
      game = FactoryBot.create(:game)
      bishop = FactoryBot.build(:bishop, game_id: game.id)
      result = bishop.is_move_valid?(6, 1)
      expect(result).to eq false
    end
  end

  describe 'move result' do
    it 'updates :x and :y to x_target and y_target if move is valid' do
      game = FactoryBot.create(:game)
      bishop = FactoryBot.build(:bishop, game_id: game.id)
      if bishop.is_move_valid?(4, 2)
        bishop.move_action(4, 2) # moves one square in 'y' direction
      end
      expect(bishop.x).to eq 4
      expect(bishop.y).to eq 2
    end

    it 'does not update :x and :y if move is invalid' do
      game = FactoryBot.create(:game)
      bishop = FactoryBot.build(:bishop, game_id: game.id)
      if bishop.is_move_valid?(2, 0)
        bishop.move_action(2, 0) # moves one square in negative 'y' direction (off the board)
      end
      expect(bishop.x).to eq 3
      expect(bishop.y).to eq 1
    end
  end
end