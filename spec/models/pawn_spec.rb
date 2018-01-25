require 'rails_helper'

RSpec.describe Pawn, type: :model do
  describe '.new' do
    # let(:pawn) { FactoryBot.create :pawn }

    it 'is valid' do
      game = FactoryBot.create(:game)
      pawn = FactoryBot.build(:pawn, game_id: game.id)
      expect(pawn).to be_valid
    end

    it '#white? is true for white pieces' do
      game = FactoryBot.create(:game)
      pawn = FactoryBot.build(:pawn, game_id: game.id)
      expect(pawn.white?).to eq true
    end

    it '#white? is false for black pieces' do
      game = FactoryBot.create(:game)
      pawn = FactoryBot.build(:pawn, game_id: game.id)
      pawn.color = 'black'
      expect(pawn.white?).to eq false
    end

    it '#black? is true for black pieces' do
      game = FactoryBot.create(:game)
      pawn = FactoryBot.build(:pawn, game_id: game.id)
      pawn.color = 'black'
      expect(pawn.black?).to eq true
    end

    it '#black? is false for white pieces' do
      game = FactoryBot.create(:game)
      pawn = FactoryBot.build(:pawn, game_id: game.id)
      expect(pawn.black?).to eq false
    end

    it 'has the correct starting position' do
      game = FactoryBot.create(:game)
      pawn = FactoryBot.build(:pawn, game_id: game.id)
      expect(pawn.x).to eq 1
      expect(pawn.y).to eq 2
    end
  end

  describe 'move validation' do
    it 'for white piece #in_range returns true if move is in pawn\'s range from starting position' do
      game = FactoryBot.create(:game)
      pawn = FactoryBot.build(:pawn, game_id: game.id)
      result = pawn.send(:in_range?, 1, 4) # if method is private
      # result = pawn.in_range?(1, 2, 1, 4) # if method not private
      expect(result).to eq true
    end

    it 'for black piece #in_range returns true if move is in pawn\'s range from starting position' do
      game = FactoryBot.create(:game)
      pawn = FactoryBot.build(:pawn, game_id: game.id)
      pawn.color = 'black'
      pawn.y = 7 # starting position for black piece
      result = pawn.send(:in_range?, 1, 5) # if method is private
      # result = pawn.in_range?(1, 7, 1, 5) # if method not private
      expect(result).to eq true
    end

    it 'for white piece #in_range returns true if move is in pawn\'s range from non-starting position' do
      game = FactoryBot.create(:game)
      pawn = FactoryBot.build(:pawn, game_id: game.id)
      pawn.update_attributes(x: 1, y: 4)
      result = pawn.send(:in_range?, 1, 5)
      expect(result).to eq true
    end

    it 'for black piece #in_range returns true if move is in pawn\'s range from non-starting position' do
      game = FactoryBot.create(:game)
      pawn = FactoryBot.build(:pawn, game_id: game.id)
      pawn.color = 'black'
      pawn.update_attributes(x: 1, y: 5)
      result = pawn.send(:in_range?, 1, 4)
      expect(result).to eq true
    end

    it 'for white piece #in_range returns false if move is not in pawn\'s range' do
      game = FactoryBot.create(:game)
      pawn = FactoryBot.build(:pawn, game_id: game.id)
      result = pawn.send(:in_range?, 8, 2)
      expect(result).to eq false
    end

    it 'for black piece #in_range returns false if move is not in pawn\'s range' do
      game = FactoryBot.create(:game)
      pawn = FactoryBot.build(:pawn, game_id: game.id)
      pawn.color = 'black'
      result = pawn.send(:in_range?, 3, 1)
      expect(result).to eq false
    end

    it '#is_move_valid? returns true if pawn\'s move is valid' do
      game = FactoryBot.create(:game)
      pawn = FactoryBot.build(:pawn, game_id: game.id)
      result = pawn.is_move_valid?(1, 3)
      expect(result).to eq true
    end

    it '#is_move_valid? returns false if pawn\'s move is off the board' do
      game = FactoryBot.create(:game)
      pawn = FactoryBot.build(:pawn, game_id: game.id)
      result = pawn.is_move_valid?(1, 9)
      expect(result).to eq false
    end

    it '#is_move_valid? returns false if pawn\'s move is out of range for pawn' do
      game = FactoryBot.create(:game)
      pawn = FactoryBot.build(:pawn, game_id: game.id)
      result = pawn.is_move_valid?(1, 6)
      expect(result).to eq false
    end

    it '#is_move_valid? returns false if pawn\'s move is obstructed' do
      game = FactoryBot.create(:game)
      pawn = FactoryBot.build(:pawn, game_id: game.id)
      pawn2 = FactoryBot.create(:pawn, game_id: game.id)
      pawn2.update_attributes(x: 1, y: 3)
      result = pawn.is_move_valid?(1, 4)
      expect(result).to eq false
    end
  end

  describe 'move result' do
    it 'updates :x and :y to x_target and y_target if move is valid' do
      game = FactoryBot.create(:game)
      pawn = FactoryBot.build(:pawn, game_id: game.id)
      if pawn.is_move_valid?(1, 3)
        pawn.move_action(1, 3) # moves one square in 'y' direction
      end
      expect(pawn.x).to eq 1
      expect(pawn.y).to eq 3
    end

    xit 'returns an "invalid move" message if move is invalid' do
      game = FactoryBot.create(:game)
      pawn = FactoryBot.build(:pawn, game_id: game.id)
      if pawn.is_move_valid?(4, 9)
        pawn.move_action(4, 9) # moves off the board
      end
      expect
    end

    it 'does not update :x and :y if move is invalid' do
      game = FactoryBot.create(:game)
      pawn = FactoryBot.build(:pawn, game_id: game.id)
      if pawn.is_move_valid?(1, 0)
        pawn.move_action(1, 0) # moves off the board
      end
      expect(pawn.x).to eq 1
      expect(pawn.y).to eq 2
    end
  end

  describe 'promotion' do
    it 'is_promotable? returns true if the white pawn can be promoted' do
      pawn = FactoryBot.build(:pawn, color: 'white', y: 8)
      expect(pawn.is_promotable?).to eq '#9813'
    end

    it 'is_promotable? returns false if the white pawn cannot be promoted' do
      pawn = FactoryBot.build(:pawn, color: 'white', y: 7)
      expect(pawn.is_promotable?).to eq false
    end

    it 'is_promotable? returns true if the black pawn can be promoted' do
      pawn = FactoryBot.build(:pawn, color: 'black', y: 1)
      expect(pawn.is_promotable?).to eq '#9819'
    end

    it 'is_promotable? returns false if the black pawn cannot be promoted' do
      pawn = FactoryBot.build(:pawn, color: 'black', y: 2)
      expect(pawn.is_promotable?).to eq false
    end
  end
end