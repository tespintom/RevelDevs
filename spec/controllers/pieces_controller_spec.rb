require 'rails_helper'

RSpec.describe PiecesController, type: :controller do

  describe 'pieces#show action' do
    it 'should successfully return the correct piece id if the piece is found' do
      game = FactoryBot.create(:game)
      piece = FactoryBot.create(:piece, game_id: game.id)
      sign_in game.white_player
      get :show, params: { id: piece.id }
      response_value = ActiveSupport::JSON.decode(@response.body)
      expect(response_value['id']).to eq(piece.id)
    end

    xit 'should successfully return the correct piece id if the piece is found' do
      game = FactoryBot.create(:game)
      piece = game.pieces.active.where({x: 1, y: 2}).first
      sign_in game.white_player
      get :show, params: { id: piece.id }
      response_value = ActiveSupport::JSON.decode(@response.body)
      expect(response_value['id']).to eq(piece.id)
      expect(response_value['type']).to eq("Pawn")
    end

    it 'should return "not_found" if no piece exists' do
      game = FactoryBot.create(:game)
      sign_in game.white_player
      get :show, params: { id: 'not_an_integer' }
      expect(response).to have_http_status :not_found
    end
  end
end
