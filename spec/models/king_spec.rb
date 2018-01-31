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
      if king.is_move_valid?(4, 2)
        king.move_action(4, 2) # moves one square in 'y' direction
      end
      expect(king.x).to eq 4
      expect(king.y).to eq 2
    end

    xit 'returns an "invalid move" message if move is invalid' do
      game = FactoryBot.create(:game)
      king = FactoryBot.build(:king, game_id: game.id)
      if king.is_move_valid?(4, 0)
        king.move_action(4, 0) # moves one square in negative 'y' direction (off the board)
      end
      expect
    end

    it 'does not update :x and :y if move is invalid' do
      game = FactoryBot.create(:game)
      king = FactoryBot.build(:king, game_id: game.id)
      if king.is_move_valid?(4, 0)
        king.move_action(4, 0) # moves one square in negative 'y' direction (off the board)
      end
      expect(king.x).to eq 4
      expect(king.y).to eq 1
    end
  end

  describe 'castling' do
    it '#in_original_position? should return true if the King has not been moved' do
      game = FactoryBot.create(:game)
      king = game.pieces.active.find_by({x: 4, y: 1})
      result = king.in_original_position?
      expect(result).to eq true
    end

    it '#in_original_position? should return false if the King has been moved' do
      game = FactoryBot.create(:game)
      king = game.pieces.active.find_by({x: 4, y: 1})
      king.update_attributes(x: 4, y: 3)
      result = king.in_original_position?
      expect(result).to eq false
    end

    it '#find_corner_piece returns the correct piece from the right' do
      game = FactoryBot.create(:game)
      king = game.pieces.active.find_by({x: 4, y: 1})
      found_piece = king.find_corner_piece(6, 1)
      rook = game.pieces.active.find_by({x: 8, y: 1})
      expect(found_piece).to eq(rook)
    end

    it '#find_corner_piece returns the correct piece from the left' do
      game = FactoryBot.create(:game)
      king = game.pieces.active.find_by({x: 4, y: 1})
      found_piece = king.find_corner_piece(2, 1)
      rook = game.pieces.active.find_by({x: 1, y: 1})
      expect(found_piece).to eq(rook)
    end

    it '#find_corner_piece returns no piece from the left if there is no piece' do
      game = FactoryBot.create(:game)
      king = game.pieces.active.find_by({x: 4, y: 1})
      rook = game.pieces.active.find_by({x: 1, y: 1})
      rook.update_attributes(captured: true, x: 0, y: 0)
      found_piece = king.find_corner_piece(2, 1)
      expect(found_piece).to eq(nil)
    end

    it '#is_rook? returns true if the piece is a rook' do
      game = FactoryBot.create(:game)
      piece = game.pieces.active.find_by({x: 1, y: 1})
      king = game.pieces.active.find_by({x: 4, y: 1})
      result = king.is_rook?(piece)
      expect(result).to eq true
    end

    it '#is_rook? returns false if the piece is not a rook' do
      game = FactoryBot.create(:game)
      piece = game.pieces.active.find_by({x: 2, y: 1})
      king = game.pieces.active.find_by({x: 4, y: 1})
      result = king.is_rook?(piece)
      expect(result).to eq false
    end

    it '#can_castle? returns true if the King is able to castle' do
      game = FactoryBot.create(:game)
      king = game.pieces.active.find_by({x: 4, y: 1})
      bishop = game.pieces.active.find_by({x: 3, y: 1})
      knight = game.pieces.active.find_by({x: 2, y: 1})
      bishop.update_attributes(captured: true, x: 0, y: 0)
      knight.update_attributes(captured: true, x: 0, y: 0)
      result = king.can_castle?(2, 1)
      expect(result).to eq true
    end

    it '#can_castle? returns false if the King isn\'t able to castle' do
      game = FactoryBot.create(:game)
      king = game.pieces.active.find_by({x: 4, y: 1})
      result = king.can_castle?(5, 1)
      expect(result).to eq false
    end

    it '#castling_obstructed? returns true if the path is obstructed' do
      game = FactoryBot.create(:game)
      king = game.pieces.active.find_by({x: 4, y: 1})
      corner_piece = king.find_corner_piece(2, 1)
      result = king.castling_obstructed?(corner_piece)
      expect(result).to eq true
    end

    it '#castling_obstructed? returns false if the path isn\'t obstructed' do
      game = FactoryBot.create(:game)
      king = game.pieces.active.find_by({x: 4, y: 1})
      bishop = game.pieces.active.find_by({x: 3, y: 1})
      knight = game.pieces.active.find_by({x: 2, y: 1})
      bishop.update_attributes(captured: true, x: 0, y: 0)
      knight.update_attributes(captured: true, x: 0, y: 0)
      corner_piece = king.find_corner_piece(2, 1)
      result = king.castling_obstructed?(corner_piece)
      expect(result).to eq false
    end

    it '#castle! performs a castling move to the left' do
      game = FactoryBot.create(:game)
      king = game.pieces.active.find_by({x: 4, y: 1})
      bishop = game.pieces.active.find_by({x: 3, y: 1})
      knight = game.pieces.active.find_by({x: 2, y: 1})
      rook = game.pieces.active.find_by({x: 1, y: 1})
      bishop.update_attributes(captured: true, x: 0, y: 0)
      knight.update_attributes(captured: true, x: 0, y: 0)
      king.castle!(2, 1)
      rook.reload
      expect(king.x).to eq(2)
      expect(king.y).to eq(1)
      expect(rook.x).to eq(3)
      expect(rook.y).to eq(1)
    end

    it '#castle! performs a castling move to the right' do
      game = FactoryBot.create(:game)
      king = game.pieces.active.find_by({x: 4, y: 1})
      bishop = game.pieces.active.find_by({x: 6, y: 1})
      knight = game.pieces.active.find_by({x: 7, y: 1})
      rook = game.pieces.active.find_by({x: 8, y: 1})
      queen = game.pieces.active.find_by({x: 5, y: 1})
      bishop.update_attributes(captured: true, x: 0, y: 0)
      knight.update_attributes(captured: true, x: 0, y: 0)
      queen.update_attributes(captured: true, x: 0, y: 0)
      king.castle!(6, 1)
      rook.reload
      expect(king.x).to eq(6)
      expect(king.y).to eq(1)
      expect(rook.x).to eq(5)
      expect(rook.y).to eq(1)
    end

    it '#king_castling_path_in_check? returns true if the king is in check' do
      game = FactoryBot.create(:game)
      king = game.pieces.active.find_by({x: 4, y: 1})
      bishop = game.pieces.active.find_by({x: 3, y: 1})
      knight = game.pieces.active.find_by({x: 2, y: 1})
      rook = game.pieces.active.find_by({x: 1, y: 1})
      pawn = game.pieces.active.find_by({x: 4, y: 2})
      black_queen = game.pieces.active.find_by({x: 5, y: 8})
      black_queen.update_attributes(x: 4, y: 3)
      bishop.update_attributes(captured: true, x: 0, y: 0)
      knight.update_attributes(captured: true, x: 0, y: 0)
      pawn.update_attributes(captured: true, x: 0, y: 0)
      result = king.king_castling_path_in_check?("white", 2, 1)
      expect(result).to eq true
    end

    it '#king_castling_path_in_check? returns true if a square on the path puts the king in check' do
      game = FactoryBot.create(:game)
      king = game.pieces.active.find_by({x: 4, y: 1})
      bishop = game.pieces.active.find_by({x: 3, y: 1})
      knight = game.pieces.active.find_by({x: 2, y: 1})
      rook = game.pieces.active.find_by({x: 1, y: 1})
      pawn = game.pieces.active.find_by({x: 3, y: 2})
      black_queen = game.pieces.active.find_by({x: 5, y: 8})
      black_queen.update_attributes(x: 3, y: 3)
      bishop.update_attributes(captured: true, x: 0, y: 0)
      knight.update_attributes(captured: true, x: 0, y: 0)
      pawn.update_attributes(captured: true, x: 0, y: 0)
      result = king.king_castling_path_in_check?("white", 2, 1)
      expect(result).to eq true
    end

    it '#king_castling_path_in_check? returns true if completing a castling move puts the king in check' do
      game = FactoryBot.create(:game)
      king = game.pieces.active.find_by({x: 4, y: 1})
      bishop = game.pieces.active.find_by({x: 3, y: 1})
      knight = game.pieces.active.find_by({x: 2, y: 1})
      rook = game.pieces.active.find_by({x: 1, y: 1})
      pawn = game.pieces.active.find_by({x: 2, y: 2})
      black_queen = game.pieces.active.find_by({x: 5, y: 8})
      black_queen.update_attributes(x: 2, y: 3)
      bishop.update_attributes(captured: true, x: 0, y: 0)
      knight.update_attributes(captured: true, x: 0, y: 0)
      pawn.update_attributes(captured: true, x: 0, y: 0)
      result = king.king_castling_path_in_check?("white", 2, 1)
      expect(result).to eq true
    end

    it '#king_castling_path_in_check? returns false if completing a castling move does not put the king in check' do
      game = FactoryBot.create(:game)
      king = game.pieces.active.find_by({x: 4, y: 1})
      bishop = game.pieces.active.find_by({x: 3, y: 1})
      knight = game.pieces.active.find_by({x: 2, y: 1})
      rook = game.pieces.active.find_by({x: 1, y: 1})
      bishop.update_attributes(captured: true, x: 0, y: 0)
      knight.update_attributes(captured: true, x: 0, y: 0)
      result = king.king_castling_path_in_check?("white", 2, 1)
      expect(result).to eq false
    end
  end
end