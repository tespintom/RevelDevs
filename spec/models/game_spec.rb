require 'rails_helper'

RSpec.describe Game, type: :model do
  describe '.new' do
    let(:game) { FactoryBot.create :game }
 
    it 'is valid' do
      expect(game).to be_valid
    end

    it 'verifies the total number of white pawns created' do
      pawns = game.pieces.white_pieces.where(type: "Pawn")
      expect(pawns.count).to eq 8
    end

    it 'verifies the total number of black pawns created' do
      pawns = game.pieces.black_pieces.where(type: "Pawn")
      expect(pawns.count).to eq 8
    end
  end

  describe 'board' do
    let(:game) { FactoryBot.create :game }
    let!(:piece) { FactoryBot.create :piece, game_id: game.id }
    let!(:user) { FactoryBot.create :user }

    xit '#square_occupied? returns true if coordinate is occupied' do
      result = game.square_occupied?(1, 1)
      expect(result).to eq true
    end

    xit '#square_occupied? returns false if coordinate is not occupied' do
      result = game.square_occupied?(2, 3)
      expect(result).to eq false
    end
  end

  describe 'players' do
    let(:user) { FactoryBot.create :user }
    let(:game) { FactoryBot.create :game, user_id: user.id }
    it 'should initialize current user as white player' do
      expect(game.white_player_id).to eq user.id
    end
  end
end
