require 'rails_helper'

RSpec.describe GamesController, type: :controller do

  describe 'games#index action' do
    it 'should successfully render the index page' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'games#new action' do
    it 'should require users to be logged in' do
      get :new
      expect(response).to redirect_to new_user_session_path
    end

    it 'should show the game form' do
      user = FactoryBot.create(:user)
      sign_in user
      get :new
      expect(response).to have_http_status(:success)
    end
  end

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

  describe 'games#show action' do
    it 'should successfully show the game page' do
      user = FactoryBot.create(:user)
      sign_in user
      game = FactoryBot.create(:game)
      get :show, params: { id: game.id }
      expect(response).to have_http_status(:success)
    end

    it 'should render not found if the game doesn\'t exist' do
      user = FactoryBot.create(:user)
      sign_in user
      get :show, params: { id: 'YAY' }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'games#join action' do
    it 'should redirect to the game path if the game can be joined' do
      user = FactoryBot.create(:user)
      sign_in user
      game = FactoryBot.create(:game)
      patch :join, params: { id: game.id }
      expect(response).to redirect_to game_path(game)
    end

    it 'should redirect to root path if the game cannot be joined' do
      game = FactoryBot.create(:game)
      sign_in game.user
      patch :join, params: { id: game.id }
      expect(response).to redirect_to root_path
    end
  end
end