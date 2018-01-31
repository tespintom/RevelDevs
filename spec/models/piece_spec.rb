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
      result = piece.horizontal_move?(4, 1)
      expect(result).to eq true
    end

    it '#horizontal_move? returns false if move is not horizontal' do
      game = FactoryBot.create(:game)
      piece = FactoryBot.build(:piece, game_id: game.id)
      result = piece.horizontal_move?(3, 4)
      expect(result).to eq false
    end

    it '#vertical_move? returns true if move is vertical' do
      game = FactoryBot.create(:game)
      piece = FactoryBot.build(:piece, game_id: game.id)
      result = piece.vertical_move?(1, 3)
      expect(result).to eq true
    end

    it '#vertical_move? returns false if move is not vertical' do
      game = FactoryBot.create(:game)
      piece = FactoryBot.build(:piece, game_id: game.id)
      result = piece.vertical_move?(2, 2)
      expect(result).to eq false
    end

    it '#diagonal_move? returns true if move is diagonal' do
      game = FactoryBot.create(:game)
      piece = FactoryBot.build(:piece, game_id: game.id)
      result = piece.diagonal_move?(3, 3)
      expect(result).to eq true
    end

    it '#diagonal_move? returns false if move is not diagonal' do
      game = FactoryBot.create(:game)
      piece = FactoryBot.build(:piece, game_id: game.id)
      result = piece.diagonal_move?(2, 3)
      expect(result).to eq false
    end

    it '#valid_move? returns true if the move is valid' do
      game = FactoryBot.create(:game)
      piece = FactoryBot.build(:piece, game_id: game.id)
      result = piece.valid_move?(2, 3)
      expect(result).to eq true
    end

    it '#valid_move? returns false if the move is not valid' do
      game = FactoryBot.create(:game)
      piece = FactoryBot.build(:piece, game_id: game.id)
      result = piece.valid_move?(9, 10)
      expect(result).to eq false
    end

    it '#is_obstructed? returns true if the move is obstructed' do
      game = FactoryBot.create(:game)
      piece = FactoryBot.build(:piece, game_id: game.id)
      piece2 = FactoryBot.build(:piece, game_id: game.id)
      piece2.update_attributes(x: 2, y: 2)
      result = piece.is_obstructed?(3, 3)
      expect(result).to eq true
    end

    it '#is_obstructed? returns false if the move is not obstructed' do
      game = FactoryBot.create(:game)
      piece = FactoryBot.build(:piece, game_id: game.id)
      piece.update_attributes(x: 3, y: 3)
      result = piece.is_obstructed?(3, 5)
      expect(result).to eq false
    end

    it '#attempt_move should successfully move a piece' do
      game = FactoryBot.create(:game)
      pawn = game.pieces.active.find_by({x: 1, y: 2})
      pawn.attempt_move(1, 4)
      expect(pawn.y).to eq(4)
    end

    it '#attempt_move shouldn\'t move a piece if it\'s illegal' do
      game = FactoryBot.create(:game)
      rook = game.pieces.active.find_by({x: 1, y: 1})
      rook.attempt_move(1, 4)
      expect(rook.y).to eq(1)
    end

    it '#attempt_move should perform castling if castling is allowed' do
      game = FactoryBot.create(:game)
      king = game.pieces.active.find_by({x: 4, y: 1})
      bishop = game.pieces.active.find_by({x: 3, y: 1})
      knight = game.pieces.active.find_by({x: 2, y: 1})
      rook = game.pieces.active.find_by({x: 1, y: 1})
      bishop.update_attributes(captured: true, x: 0, y: 0)
      knight.update_attributes(captured: true, x: 0, y: 0)
      king.attempt_move(2, 1)
      rook.reload
      expect(king.x).to eq(2)
      expect(king.y).to eq(1)
      expect(rook.x).to eq(3)
      expect(rook.y).to eq(1)
    end

    it '#attempt_move shouldn\'t perform castling if castling isn\'t allowed' do
      game = FactoryBot.create(:game)
      king = game.pieces.active.find_by({x: 4, y: 1})
      rook = game.pieces.active.find_by({x: 1, y: 1})
      king.attempt_move(2, 1)
      rook.reload
      expect(king.x).to eq(4)
      expect(king.y).to eq(1)
      expect(rook.x).to eq(1)
      expect(rook.y).to eq(1)
    end
  end

  describe 'capture' do
    it '#is_capturable? returns true if target can be captured' do
      game = FactoryBot.create(:game)
      piece = FactoryBot.build(:piece, game_id: game.id, x: 3, y: 3)
      x_target = 3
      y_target = 7
      result = piece.is_capturable?(x_target, y_target)
      expect(result).to eq true
    end

    it '#is_capturable? returns false if target cannot be captured' do
      game = FactoryBot.create(:game)
      piece = FactoryBot.build(:piece, game_id: game.id, x: 3, y: 3)
      x_target = 3
      y_target = 2
      result = piece.is_capturable?(x_target, y_target)
      expect(result).to eq false
    end

    it '#is_capturable? returns true if the white pawn can capture a piece on the target square' do
      game = FactoryBot.create(:game)
      pawn = game.pieces.active.find_by({x: 1, y: 2})
      x_target = 2
      y_target = 3
      piece = FactoryBot.create(:piece, game_id: game.id, x: x_target, y: y_target, color: "black")
      result = pawn.is_capturable?(x_target, y_target)
      expect(result).to eq true
    end

    it '#is_capturable? returns false if the white pawn cannot capture a piece on the target square' do
      game = FactoryBot.create(:game)
      pawn = game.pieces.active.find_by({x: 1, y: 2})
      x_target = 1
      y_target = 3
      piece = FactoryBot.create(:piece, game_id: game.id, x: x_target, y: y_target, color: "black")
      result = pawn.is_capturable?(x_target, y_target)
      expect(result).to eq false
    end

    it '#is_capturable? returns true if the black pawn can capture a piece on the target square' do
      game = FactoryBot.create(:game)
      pawn = game.pieces.active.find_by({x: 1, y: 7})
      x_target = 2
      y_target = 6
      piece = FactoryBot.create(:piece, game_id: game.id, x: x_target, y: y_target)
      result = pawn.is_capturable?(x_target, y_target)
      expect(result).to eq true
    end

    it '#is_capturable? returns false if the black pawn cannot capture a piece on the target square' do
      game = FactoryBot.create(:game)
      pawn = game.pieces.active.find_by({x: 1, y: 7})
      x_target = 1
      y_target = 6
      piece = FactoryBot.create(:piece, game_id: game.id, x: x_target, y: y_target)
      result = pawn.is_capturable?(x_target, y_target)
      expect(result).to eq false
    end

    it '#captured! correctly updates "captured," "x," and "y" attributes if target is capturable' do
      game = FactoryBot.create(:game)
      piece = FactoryBot.build(:piece, game_id: game.id, x: 3, y: 3)
      x_target = 3
      y_target = 7
      target_piece = game.pieces.active.where({x: x_target, y: y_target}).first
      piece.captured!(x_target, y_target)
      target_piece.reload
      expect(target_piece.captured).to eq true
      expect(target_piece.x).to eq 0
      expect(target_piece.y).to eq 0
    end

    it '#captured! correctly moves piece to new location if target is capturable' do
      game = FactoryBot.create(:game)
      piece = FactoryBot.build(:piece, game_id: game.id, x: 3, y: 3)
      x_target = 3
      y_target = 7
      target_piece = game.pieces.active.where({x: x_target, y: y_target}).first
      piece.captured!(x_target, y_target)
      target_piece.reload
      expect(piece.x).to eq x_target
      expect(piece.y).to eq y_target
    end
  end

  describe '#piece_color_matches_user_color?' do

    it '#piece_color_matches_user_color? returns true if the piece color and user color match' do
      game = FactoryBot.create(:game)
      piece = game.pieces.active.find_by({x: 1, y: 2})
      user = game.user
      result = piece.piece_color_matches_user_color?(user)
      expect(result).to eq true
    end

    it '#piece_color_matches_user_color? returns false if the piece color and the user color don\'t match' do
      game = FactoryBot.create(:game)
      piece = game.pieces.active.find_by({x: 1, y: 7})
      user = game.user
      result = piece.piece_color_matches_user_color?(user)
      expect(result).to eq false
    end
  end

  describe 'pawn promotion' do
    it "should update the pawn type to queen if #is_promotable? returns true" do
      game = FactoryBot.create(:game)
      piece = game.pieces.active.find_by({x: 1, y: 7})
      piece.update(color: 'white')
      rook = game.pieces.active.find_by({x: 1, y: 8})
      rook.update_attributes(captured: true, x: 0, y: 0)
      piece.move_action(1, 8)
      expect(piece.type).to eq("Queen")
    end
  end
end
