require 'rails_helper'

RSpec.describe King, type: :model do
  describe '.new' do
    let(:king) { FactoryBot.create :king }

    xit 'is valid' do
      expect(king).to be_valid
    end

    xit '#white? is true for white pieces' do
      expect(king.white?).to eq true
    end

    xit '#white? is false for black pieces' do
      king.color = 'black'
      expect(king.white?).to eq false
    end

    xit '#black? is true for black pieces' do
      king.color = 'black'
      expect(king.black?).to eq true
    end

    xit '#black? is false for white pieces' do
      expect(king.black?).to eq false
    end

    xit 'has the correct starting position' do
      expect(king.x).to eq 4
      expect(king.y).to eq 1
    end
  end

  describe 'move validation' do
    let(:king) { FactoryBot.create :king }

    xit '#in_king_range returns true if horizontal move is in king\'s range' do
      result = king.send(:in_king_range?, 4, 1, 5, 1) # if method is private
      # if not private: result = king.in_king_range?(4, 1, 5, 1)
      expect(result).to eq true
    end

    xit '#in_king_range returns true if vertical move is in king\'s range' do
      result = king.send(:in_king_range?, 4, 1, 4, 2)
      expect(result).to eq true
    end

    xit '#in_king_range returns true if diagonal move is in king\'s range' do
      result = king.send(:in_king_range?, 4, 1, 5, 2)
      expect(result).to eq true
    end

    xit '#in_king_range returns false if move is not in king\'s range' do
      result = king.send(:in_king_range?, 4, 1, 8, 2)
      expect(result).to eq false
    end

    xit '#is_king_move_valid? returns true if king\'s move is valid' do
      result = king.is_king_move_valid?(4, 1, 5, 2)
      expect(result).to eq true
    end

    xit '#is_king_move_valid? returns false if king\'s move is off the board' do
      result = king.is_king_move_valid?(4, 1, 4, 0)
      expect(result).to eq false
    end

    xit '#is_king_move_valid? returns false if king\'s move is out of range for king' do
      result = king.is_king_move_valid?(4, 1, 6, 1)
      expect(result).to eq false
    end

    xit '#is_king_move_valid? returns false if king\'s move is obstructed' do
      let(:pawn) { FactoryBot.create :pawn }
      pawn.x = 4
      pawn.y = 2
      result = king.is_king_move_valid?(4, 1, 4, 2)
      expect(result).to eq false
    end
  end

  describe 'move result' do
    let(:king) { FactoryBot.create :king }

    xit 'updates :x and :y to x_target and y_target if move is valid' do
      king.move_action(4, 1, 4, 2) # moves one square in 'y' direction

      expect(king.x).to eq 4
      expect(king.y).to eq 2
    end

    xit 'returns an "invalid move" message if move is invalid' do
      king.move_action(4, 1, 4, 0) # moves one square in negative 'y' direction (off the board)

    end

    xit 'does not update :x and :y if move is invalid' do
      king.move_action(4, 1, 4, 0) # moves one square in negative 'y' direction (off the board)

      expect(king.x).to eq 4
      expect(king.y).to eq 1
    end
  end
end