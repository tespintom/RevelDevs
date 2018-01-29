require 'rails_helper'
require 'pry'

RSpec.describe PiecesController, type: :controller do

  describe 'pieces#show action' do
    it 'should return "not_found" if no piece exists' do
      game = FactoryBot.create(:game)
      sign_in game.user
      get :show, params: { id: 'not_an_integer' }
      expect(response).to have_http_status :not_found
    end

    it 'should return success if the piece color matches the user color and it\'s the correct user\'s turn' do
      game = FactoryBot.create(:game)
      piece = game.pieces.active.find_by({x: 1, y: 2})
      sign_in game.user
      game.state = "white_turn"
      game.save
      get :show, params: { id: piece.id }
      expect(response).to have_http_status :success
    end

    it 'should return render_not_found if the piece color doesn\'t match the user color' do
      game = FactoryBot.create(:game)
      piece = game.pieces.active.find_by({x: 1, y: 7})
      sign_in game.user
      get :show, params: { id: piece.id }
      expect(response).to have_http_status :not_found
    end
  end

  describe 'pieces#update action' do
    it 'should correctly update the piece\'s :x and :y if the move is valid' do
      game = FactoryBot.create(:game)
      piece = game.pieces.active.find_by({x: 1, y: 2})
      sign_in game.user
      patch :update, params: { id: piece.id, piece: { x: 1, y: 3 } }
      expect(response).to have_http_status :success
      piece.reload
      expect(piece.x).to eq(1)
      expect(piece.y).to eq(3)
    end

    it 'should not update the piece\'s :x and :y if the move is not valid' do
      game = FactoryBot.create(:game)
      piece = game.pieces.active.find_by({x: 1, y: 2})
      sign_in game.user
      patch :update, params: { id: piece.id, piece: { x: 1, y: 5 } }
      expect(response).to have_http_status :not_found
      piece.reload
      expect(piece.x).to eq(1)
      expect(piece.y).to eq(2)
    end

    it 'should correctly update the king\'s and rook\'s :x and :y upon a valid castling move' do
      game = FactoryBot.create(:game)
      sign_in game.user
      king = game.pieces.active.find_by({x: 4, y: 1})
      bishop = game.pieces.active.find_by({x: 3, y: 1})
      knight = game.pieces.active.find_by({x: 2, y: 1})
      rook = game.pieces.active.find_by({x: 1, y: 1})
      bishop.update_attributes(captured: true, x: 0, y: 0)
      knight.update_attributes(captured: true, x: 0, y: 0)

      patch :update, params: { id: king.id, piece: { x: 2, y: 1 } }

      expect(response).to have_http_status :success
      king.reload
      rook.reload
      expect(king.x).to eq(2)
      expect(king.y).to eq(1)
      expect(rook.x).to eq(3)
      expect(rook.y).to eq(1)
    end

    it 'should change the game state to reflect the correct player\'s turn' do
      game = FactoryBot.create(:game)
      piece = game.pieces.active.find_by({x: 1, y: 2})
      sign_in game.user
      game.state = "white_turn"
      game.save
      patch :update, params: { id: piece.id, piece: { x: 1, y: 3 } }
      game.reload
      expect(game.state).to eq("black_turn")
    end

    it 'player\'s turn should not change if the move was unsuccessful' do
      game = FactoryBot.create(:game)
      piece = game.pieces.active.find_by({x: 1, y: 2})
      sign_in game.user
      game.state = "white_turn"
      game.save
      patch :update, params: { id: piece.id, piece: { x: 1, y: 5 } }
      game.reload
      expect(game.state).to eq("white_turn")
    end
  end
end
