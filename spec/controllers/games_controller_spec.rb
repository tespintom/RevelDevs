require 'rails_helper'

RSpec.describe GamesController, type: :controller do

  describe 'games#create action' do
    it 'should successfully create a game' do
      user = FactoryBot.create(:user)
      sign_in user
      post :create, params: { game: { name: "game1" } }
      game = Game.last
      expect(game.name).to eq("game1")
      expect(game.user).to eq(user)
      expect(response).to redirect_to game_path(game)
    end
  end

end