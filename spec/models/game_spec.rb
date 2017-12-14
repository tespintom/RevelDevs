require 'rails_helper'

RSpec.describe Game, type: :model do
  describe '.new' do
    let(:game) { FactoryBot.create :game }
 
    it 'is valid' do
      expect(game).to be_valid
    end
  end

  describe 'board' do
    let(:game) { FactoryBot.create :game }
    let!(:piece) { FactoryBot.create :piece, game_id: game.id }

    xit '#square_occupied? returns true if coordinate is occupied' do
      result = game.square_occupied?(1, 1)
      expect(result).to eq true
    end

    xit '#square_occupied? returns false if coordinate is not occupied' do
      result = game.square_occupied?(2, 3)
      expect(result).to eq false
    end
  end


  describe 'available' do
    let(:game) {FactoryBot.create :game}

    xit 'should show available games, which are games with total_players = 1' do
      result = Game.available.count
      expect(result).to eq(1)

  describe 'players' do
    let(:game) { FactoryBot.create :game }
    xit 'should initialize current user as white player' do
      user = FactoryBot.create(:user)
      expect(game.white_player_id).to eq current_user.id

    end
  end
end
