require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  describe "games#index action" do
    it "should successfully show the page" do
      get :index  
      expect(response).to have_http_status(:success)
    end

    it "should show a list of available games, where total players = 1" do
      game = FactoryBot.create(:game)
      game = FactoryBot.create(:game)
      expect(Game.available.count).to eq(2)
    end
  end
end
