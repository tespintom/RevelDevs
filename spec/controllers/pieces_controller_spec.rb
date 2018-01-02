require 'rails_helper'

RSpec.describe PiecesController, type: :controller do

  describe '.show' do
    it 'should successfully return the piece if the piece is found' do
      game = FactoryBot.build(:game)
      piece = FactoryBot.build(:piece, game_id: game.id, id: 1)
      get :show, params: { id: piece.id }
      expect(response).to have_http_status(:success)
    end
  end 

end
