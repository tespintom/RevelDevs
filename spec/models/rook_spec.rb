require 'rails_helper'

RSpec.describe Rook, type: :model do
  describe '.new' do
    it 'is valid' do
      game = FactoryBot.create(:game)
      rook = FactoryBot.build(:rook, game_id: game.id)
      expect(rook).to be_valid
    end

    it '#white? is true for white pieces' do
      game = FactoryBot.create(:game)
      rook = FactoryBot.build(:rook, game_id: game.id)
      expect(rook.white?).to eq true
    end

    it '#white? is false for black pieces' do
      game = FactoryBot.create(:game)
      rook = FactoryBot.build(:rook, game_id: game.id)
      rook.color = 'black'
      expect(rook.white?).to eq false
    end

    it '#black? is true for black pieces' do
      game = FactoryBot.create(:game)
      rook = FactoryBot.build(:rook, game_id: game.id)
      rook.color = 'black'
      expect(rook.black?).to eq true
    end

    it '#black? is false for white pieces' do
      game = FactoryBot.create(:game)
      rook = FactoryBot.build(:rook, game_id: game.id)
      expect(rook.black?).to eq false
    end

    it 'has the correct starting position' do
      game = FactoryBot.create(:game)
      rook = FactoryBot.build(:rook, game_id: game.id)
      expect(rook.x).to eq 1
      expect(rook.y).to eq 1
    end
  end

  describe 'move validation' do
    it '#in_range returns true if horizontal move ' do
      game = FactoryBot.create(:game)
      rook = FactoryBot.build(:rook, game_id: game.id)
      result = rook.send(:in_range?, 4, 1) # if method is private
      # if not private: result = rook.in_range?(4, 1, 5, 1)
      expect(result).to eq true
    end

    it '#in_range returns false if vertical move' do
      game = FactoryBot.create(:game)
      rook = FactoryBot.build(:rook, game_id: game.id)
      result = rook.send(:in_range?, 3, 2)
      expect(result).to eq false
    end

    it '#in_range returns false if diagonal move' do
      game = FactoryBot.create(:game)
      rook = FactoryBot.build(:rook, game_id: game.id)
      result = rook.send(:in_range?, 2, 2)
      expect(result).to eq false
    end

    it '#in_range returns false if move is not in rook\'s range' do
      game = FactoryBot.create(:game)
      rook = FactoryBot.build(:rook, game_id: game.id)
      result = rook.send(:in_range?, 8, 2)
      expect(result).to eq false
    end

    it '#is_move_valid? returns true if rook\'s move is valid' do
      game = FactoryBot.create(:game)
      rook = FactoryBot.build(:rook, game_id: game.id)
      result = rook.is_move_valid?(1, 7)
      expect(result).to eq true
    end

    it '#is_move_valid? returns false if rook\'s move is off the board' do
      game = FactoryBot.create(:game)
      rook = FactoryBot.build(:rook, game_id: game.id)
      result = rook.is_move_valid?(4, 0)
      expect(result).to eq false
    end

    it '#is_move_valid? returns false if rook\'s move is out of range for rook' do
      game = FactoryBot.create(:game)
      rook = FactoryBot.build(:rook, game_id: game.id)
      result = rook.is_move_valid?(8, 3)
      expect(result).to eq false
    end
  end

  describe 'move result' do
    it 'updates :x and :y to x_target and y_target if move is valid' do
      game = FactoryBot.create(:game)
      rook = FactoryBot.build(:rook, game_id: game.id)
      rook.move_action(4, 1) # moves one square in 'y' direction

      expect(rook.x).to eq 4
      expect(rook.y).to eq 1
    end

    xit 'returns an "invalid move" message if move is invalid' do
      game = FactoryBot.create(:game)
      rook = FactoryBot.build(:rook, game_id: game.id)
      rook.move_action(4, 0) # moves one square in negative 'y' direction (off the board)

      expect
    end

    it 'does not update :x and :y if move is invalid' do
      game = FactoryBot.create(:game)
      rook = FactoryBot.build(:rook, game_id: game.id)
      rook.move_action(1, 0) # moves one square in negative 'y' direction (off the board)

      expect(rook.x).to eq 1
      expect(rook.y).to eq 1
    end
  end
end