require 'rails_helper'

RSpec.describe Queen, type: :model do
  describe '.new' do
    it 'is valid' do
      game = FactoryBot.create(:game)
      queen = FactoryBot.build(:queen, game_id: game.id)
      expect(queen).to be_valid
    end

    it '#white? is true for white pieces' do
      game = FactoryBot.create(:game)
      queen = FactoryBot.build(:queen, game_id: game.id)
      expect(queen.white?).to eq true
    end

    it '#white? is false for black pieces' do
      game = FactoryBot.create(:game)
      queen = FactoryBot.build(:queen, game_id: game.id)
      queen.color = 'black'
      expect(queen.white?).to eq false
    end

    it '#black? is true for black pieces' do
      game = FactoryBot.create(:game)
      queen = FactoryBot.build(:queen, game_id: game.id)
      queen.color = 'black'
      expect(queen.black?).to eq true
    end

    it '#black? is false for white pieces' do
      game = FactoryBot.create(:game)
      queen = FactoryBot.build(:queen, game_id: game.id)
      expect(queen.black?).to eq false
    end

    it 'has the correct starting position' do
      game = FactoryBot.create(:game)
      queen = FactoryBot.build(:queen, game_id: game.id)
      expect(queen.x).to eq 5
      expect(queen.y).to eq 1
    end
  end

  describe 'move validation' do
    it '#in_range returns true if horizontal move is in queen\'s range' do
      game = FactoryBot.create(:game)
      queen = FactoryBot.build(:queen, game_id: game.id)
      result = queen.send(:in_range?, 8, 1) # if method is private
      # if not private: result = queen.in_range?(4, 1, 5, 1)
      expect(result).to eq true
    end

    it '#in_range returns true if vertical move is in queen\'s range' do
      game = FactoryBot.create(:game)
      queen = FactoryBot.build(:queen, game_id: game.id)
      result = queen.send(:in_range?, 5, 5)
      expect(result).to eq true
    end

    it '#in_range returns true if diagonal move is in queen\'s range' do
      game = FactoryBot.create(:game)
      queen = FactoryBot.build(:queen, game_id: game.id)
      result = queen.send(:in_range?, 7, 3)
      expect(result).to eq true
    end

    it '#in_range returns false if move is not in queen\'s range' do
      game = FactoryBot.create(:game)
      queen = FactoryBot.build(:queen, game_id: game.id)
      result = queen.send(:in_range?, 8, 2)
      expect(result).to eq false
    end

    it '#is_move_valid? returns true if queen\'s move is valid' do
      game = FactoryBot.create(:game)
      queen = FactoryBot.build(:queen, game_id: game.id)
      result = queen.is_move_valid?(5, 2)
      expect(result).to eq true
    end

    it '#is_move_valid? returns false if queen\'s move is off the board' do
      game = FactoryBot.create(:game)
      queen = FactoryBot.build(:queen, game_id: game.id)
      result = queen.is_move_valid?(4, 0)
      expect(result).to eq false
    end

    it '#is_move_valid? returns false if queen\'s move is out of range for queen' do
      game = FactoryBot.create(:game)
      queen = FactoryBot.build(:queen, game_id: game.id)
      result = queen.is_move_valid?(5, 0)
      expect(result).to eq false
    end
  end

  describe 'move result' do
    it 'updates :x and :y to x_target and y_target if move is valid' do
      game = FactoryBot.create(:game)
      queen = FactoryBot.build(:queen, game_id: game.id)
      queen.move_action(4, 2) # moves one square in 'y' direction

      expect(queen.x).to eq 4
      expect(queen.y).to eq 2
    end

    xit 'returns an "invalid move" message if move is invalid' do
      game = FactoryBot.create(:game)
      queen = FactoryBot.build(:queen, game_id: game.id)
      queen.move_action(4, 0) # moves one square in negative 'y' direction (off the board)

      expect
    end

    it 'does not update :x and :y if move is invalid' do
      game = FactoryBot.create(:game)
      queen = FactoryBot.build(:queen, game_id: game.id)
      queen.move_action(5, 0) # moves one square in negative 'y' direction (off the board)

      expect(queen.x).to eq 5
      expect(queen.y).to eq 1
    end
  end
end