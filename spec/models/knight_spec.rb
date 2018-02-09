require 'rails_helper'

RSpec.describe Knight, type: :model do
  describe '.new' do
    it 'is valid' do
      game = FactoryBot.create(:game)
      knight = FactoryBot.build(:knight, game_id: game.id)
      expect(knight).to be_valid
    end

    it '#white? is true for white pieces' do
      game = FactoryBot.create(:game)
      knight = FactoryBot.build(:knight, game_id: game.id)
      expect(knight.white?).to eq true
    end

    it '#white? is false for black pieces' do
      game = FactoryBot.create(:game)
      knight = FactoryBot.build(:knight, game_id: game.id)
      knight.color = 'black'
      expect(knight.white?).to eq false
    end

    it '#black? is true for black pieces' do
      game = FactoryBot.create(:game)
      knight = FactoryBot.build(:knight, game_id: game.id)
      knight.color = 'black'
      expect(knight.black?).to eq true
    end

    it '#black? is false for white pieces' do
      game = FactoryBot.create(:game)
      knight = FactoryBot.build(:knight, game_id: game.id)
      expect(knight.black?).to eq false
    end

    it 'has the correct starting position' do
      game = FactoryBot.create(:game)
      knight = FactoryBot.build(:knight, game_id: game.id)
      expect(knight.x).to eq 2
      expect(knight.y).to eq 1
    end
  end

  describe 'move validation' do
    it '#in_range returns true if  move is in knight\'s range moving 1 square x and 2 squares y' do
      game = FactoryBot.create(:game)
      knight = FactoryBot.build(:knight, game_id: game.id)
      result = knight.send(:in_range?, 3, 3) # if method is private
      # if not private: result = knight.in_range?(4, 1, 5, 1)
      expect(result).to eq true
    end

    it '#in_range returns true if move is in knight\'s range moving 2 squares x and 1 square y' do
      game = FactoryBot.create(:game)
      knight = FactoryBot.build(:knight, game_id: game.id)
      result = knight.send(:in_range?, 4, 2)
      expect(result).to eq true
    end


    it '#in_range returns false if move is not in knight\'s range' do
      game = FactoryBot.create(:game)
      knight = FactoryBot.build(:knight, game_id: game.id)
      result = knight.send(:in_range?, 8, 2)
      expect(result).to eq false
    end

    it '#is_move_valid? returns true if knight\'s move is valid' do
      game = FactoryBot.create(:game)
      knight = FactoryBot.build(:knight, game_id: game.id)
      result = knight.is_move_valid?(3, 3)
      expect(result).to eq true
    end

    it '#is_move_valid? returns false if knight\'s move is off the board' do
      game = FactoryBot.create(:game)
      knight = FactoryBot.build(:knight, game_id: game.id)
      result = knight.is_move_valid?(4, 0)
      expect(result).to eq false
    end

    it '#is_move_valid? returns false if knight\'s move is out of range for knight' do
      game = FactoryBot.create(:game)
      knight = FactoryBot.build(:knight, game_id: game.id)
      result = knight.is_move_valid?(6, 1)
      expect(result).to eq false
    end
  end

  describe 'move result' do
    it 'updates :x and :y to x_target and y_target if move is valid' do
      game = FactoryBot.create(:game)
      knight = FactoryBot.build(:knight, game_id: game.id)
      if knight.is_move_valid?(4, 2)
        knight.move_action(4, 2) # moves one square in 'y' direction
      end
      expect(knight.x).to eq 4
      expect(knight.y).to eq 2
    end

    it 'does not update :x and :y if move is invalid' do
      game = FactoryBot.create(:game)
      knight = FactoryBot.build(:knight, game_id: game.id)
      if knight.is_move_valid?(4, 0)
        knight.move_action(4, 0) # moves one square in negative 'y' direction (off the board)
      end
      expect(knight.x).to eq 2
      expect(knight.y).to eq 1
    end
  end
end