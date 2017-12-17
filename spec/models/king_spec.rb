require 'rails_helper'

RSpec.describe King, type: :model do
  describe '.new' do
    it 'is valid' do
      game = FactoryBot.create(:game)
      king = FactoryBot.build(:king, game_id: game.id)
      expect(king).to be_valid
    end

    it '#white? is true for white pieces' do
      game = FactoryBot.create(:game)
      king = FactoryBot.build(:king, game_id: game.id)
      expect(king.white?).to eq true
    end

    it '#white? is false for black pieces' do
      game = FactoryBot.create(:game)
      king = FactoryBot.build(:king, game_id: game.id)
      king.color = 'black'
      expect(king.white?).to eq false
    end

    it '#black? is true for black pieces' do
      game = FactoryBot.create(:game)
      king = FactoryBot.build(:king, game_id: game.id)
      king.color = 'black'
      expect(king.black?).to eq true
    end

    it '#black? is false for white pieces' do
      game = FactoryBot.create(:game)
      king = FactoryBot.build(:king, game_id: game.id)
      expect(king.black?).to eq false
    end

    it 'has the correct starting position' do
      game = FactoryBot.create(:game)
      king = FactoryBot.build(:king, game_id: game.id)
      expect(king.x).to eq 4
      expect(king.y).to eq 1
    end
  end

  describe 'move validation' do
    it '#in_range returns true if horizontal move is in king\'s range' do
      game = FactoryBot.create(:game)
      king = FactoryBot.build(:king, game_id: game.id)
      result = king.send(:in_range?, 5, 1) # if method is private
      # if not private: result = king.in_range?(4, 1, 5, 1)
      expect(result).to eq true
    end

    it '#in_range returns true if vertical move is in king\'s range' do
      game = FactoryBot.create(:game)
      king = FactoryBot.build(:king, game_id: game.id)
      result = king.send(:in_range?, 4, 2)
      expect(result).to eq true
    end

    it '#in_range returns true if diagonal move is in king\'s range' do
      game = FactoryBot.create(:game)
      king = FactoryBot.build(:king, game_id: game.id)
      result = king.send(:in_range?, 5, 2)
      expect(result).to eq true
    end

    it '#in_range returns false if move is not in king\'s range' do
      game = FactoryBot.create(:game)
      king = FactoryBot.build(:king, game_id: game.id)
      result = king.send(:in_range?, 8, 2)
      expect(result).to eq false
    end

    it '#is_move_valid? returns true if king\'s move is valid' do
      game = FactoryBot.create(:game)
      king = FactoryBot.build(:king, game_id: game.id)
      result = king.is_move_valid?(5, 2)
      expect(result).to eq true
    end

    it '#is_move_valid? returns false if king\'s move is off the board' do
      game = FactoryBot.create(:game)
      king = FactoryBot.build(:king, game_id: game.id)
      result = king.is_move_valid?(4, 0)
      expect(result).to eq false
    end

    it '#is_move_valid? returns false if king\'s move is out of range for king' do
      game = FactoryBot.create(:game)
      king = FactoryBot.build(:king, game_id: game.id)
      result = king.is_move_valid?(6, 1)
      expect(result).to eq false
    end
  end

  describe 'move result' do
    it 'updates :x and :y to x_target and y_target if move is valid' do
      game = FactoryBot.create(:game)
      king = FactoryBot.build(:king, game_id: game.id)
      king.move_action(4, 2) # moves one square in 'y' direction

      expect(king.x).to eq 4
      expect(king.y).to eq 2
    end

    xit 'returns an "invalid move" message if move is invalid' do
      game = FactoryBot.create(:game)
      king = FactoryBot.build(:king, game_id: game.id)
      king.move_action(4, 0) # moves one square in negative 'y' direction (off the board)

      expect
    end

    it 'does not update :x and :y if move is invalid' do
      game = FactoryBot.create(:game)
      king = FactoryBot.build(:king, game_id: game.id)
      king.move_action(4, 0) # moves one square in negative 'y' direction (off the board)

      expect(king.x).to eq 4
      expect(king.y).to eq 1
    end
  end
end