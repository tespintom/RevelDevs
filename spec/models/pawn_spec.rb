require 'rails_helper'

RSpec.describe Pawn, type: :model do
  describe '.new' do
    let(:pawn) { FactoryBot.create :pawn }

    it 'is valid' do
      expect(pawn).to be_valid
    end

    it '#white? is true for white pieces' do
      expect(pawn.white?).to eq true
    end

    it '#white? is false for black pieces' do
      pawn.color = 'black'
      expect(pawn.white?).to eq false
    end

    it '#black? is true for black pieces' do
      pawn.color = 'black'
      expect(pawn.black?).to eq true
    end

    it '#black? is false for white pieces' do
      expect(pawn.black?).to eq false
    end

    it 'has the correct starting position' do
      expect(pawn.x).to eq 1
      expect(pawn.y).to eq 2
    end
  end

  describe 'move validation' do
    let(:game) { FactoryBot.create :game}
    let!(:pawn) { FactoryBot.create :pawn, game_id: game.id}

    it 'for white piece #in_pawn_range returns true if move is in pawn\'s range from starting position' do
      result = pawn.send(:in_pawn_range?, 1, 2, 1, 4) # if method is private
      # result = pawn.in_pawn_range?(1, 2, 1, 4) # if method not private
      expect(result).to eq true
    end

    it 'for black piece #in_pawn_range returns true if move is in pawn\'s range from starting position' do
      pawn.color = 'black'
      pawn.y = 7 # starting position for black piece
      result = pawn.send(:in_pawn_range?, 1, 7, 1, 5) # if method is private
      # result = pawn.in_pawn_range?(1, 7, 1, 5) # if method not private
      expect(result).to eq true
    end

    it 'for white piece #in_pawn_range returns true if move is in pawn\'s range from non-starting position' do
      result = pawn.send(:in_pawn_range?, 1, 4, 1, 5)
      expect(result).to eq true
    end

    it 'for black piece #in_pawn_range returns true if move is in pawn\'s range from non-starting position' do
      pawn.color = 'black'
      result = pawn.send(:in_pawn_range?, 1, 5, 1, 4)
      expect(result).to eq true
    end

    it 'for white piece #in_pawn_range returns false if move is not in pawn\'s range' do
      result = pawn.send(:in_pawn_range?, 1, 2, 8, 2)
      expect(result).to eq false
    end

    it 'for black piece #in_pawn_range returns false if move is not in pawn\'s range' do
      pawn.color = 'black'
      result = pawn.send(:in_pawn_range?, 1, 7, 3, 1)
      expect(result).to eq false
    end

    xit '#is_pawn_move_valid? returns true if pawn\'s move is valid' do
      result = pawn.is_pawn_move_valid?(1, 2, 1, 3)
      expect(result).to eq true
    end

    it '#is_pawn_move_valid? returns false if pawn\'s move is off the board' do
      result = pawn.is_pawn_move_valid?(1, 2, 1, 9)
      expect(result).to eq false
    end

    it '#is_pawn_move_valid? returns false if pawn\'s move is out of range for pawn' do
      result = pawn.is_pawn_move_valid?(1, 3, 1, 6)
      expect(result).to eq false
    end

    it '#is_pawn_move_valid? returns false if pawn\'s move is obstructed' do
      king = FactoryBot.create(:king, game_id: game.id)
      king.x = 1
      king.y = 3
      result = pawn.is_pawn_move_valid?(1, 2, 1, 4)
      expect(result).to eq false
    end
  end

  describe 'move result' do
    let(:pawn) { FactoryBot.create :pawn }

    xit 'updates :x and :y to x_target and y_target if move is valid' do
      pawn.move_action(1, 2, 1, 3) # moves one square in 'y' direction

      expect(pawn.x).to eq 1
      expect(pawn.y).to eq 3
    end

    it 'returns an "invalid move" message if move is invalid' do
      pawn.move_action(4, 2, 4, 9) # moves off the board

    end

    it 'does not update :x and :y if move is invalid' do
      pawn.move_action(1, 2, 1, 0) # moves off the board

      expect(pawn.x).to eq 1
      expect(pawn.y).to eq 2
    end
  end
end