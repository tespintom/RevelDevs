require 'rails_helper'
require 'pry'

RSpec.describe PiecesController, type: :controller do

  describe 'pieces#show action' do
    xit 'should have http status "success" if the piece is found' do
      game = FactoryBot.create(:game)
      piece = FactoryBot.create(:piece, game_id: game.id)
      sign_in game.user
      get :show, params: { id: piece.id }

      # # Use this if rendering JSON
      # response_value = ActiveSupport::JSON.decode(@response.body)
      # expect(response_value['id']).to eq(piece.id)

      # Use this if not rendering JSON
      expect(response).to have_http_status(:success)
    end

    xit 'should successfully return the correct piece id if the piece is found' do
      # game = FactoryBot.create(:game)
      user = FactoryBot.create(:user)
      sign_in user
      game = user.games.create(name: "game1")
      piece = game.pieces.active.where({x: 1, y: 2}).first
      # sign_in game.user
      get :show, params: { id: piece.id }
      response_value = ActiveSupport::JSON.decode(@response.body)
      binding.pry
      expect(response_value['id']).to eq(piece.id)
      expect(response_value['color']).to eq("white")
      expect(response_value['type']).to eq("Pawn")
    end

    it 'should return "not_found" if no piece exists' do
      game = FactoryBot.create(:game)
      sign_in game.user
      get :show, params: { id: 'not_an_integer' }
      expect(response).to have_http_status :not_found
    end

    it 'should return success if the piece color matches the user color' do
      game = FactoryBot.create(:game)
      piece = game.pieces.active.find_by({x: 1, y: 2})
      sign_in game.user
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
