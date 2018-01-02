require 'rails_helper'

RSpec.describe PiecesController, type: :controller do

  describe 'pieces#show action' do
    it 'should successfully return the piece if the piece is found' do
      game = FactoryBot.create(:game)
      #piece = game.pieces.active.where({x: 1, y: 1}).first
      piece = FactoryBot.create(:piece, game_id: game.id, id: 1)
      sign_in game.white_player
      get :show, params: { id: 1 }
      expect(response).to have_http_status :success

      # use todo app as reference for writing tests associated with JSON
    end
  end 
end
