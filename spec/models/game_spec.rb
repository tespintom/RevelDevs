require 'rails_helper'

RSpec.describe Game, type: :model do
  describe '.new' do
    it 'is valid' do
      game = FactoryBot.create(:game)
      expect(game).to be_valid
    end

    it 'verifies that white pieces are in the correct locations' do
      game = FactoryBot.create(:game)
      piece_locations = [{type: 'Pawn', x: 1, y: 2},
        {type: 'Pawn', x: 2, y: 2},
        {type: 'Pawn', x: 3, y: 2},
        {type: 'Pawn', x: 4, y: 2},
        {type: 'Pawn', x: 5, y: 2},
        {type: 'Pawn', x: 6, y: 2},
        {type: 'Pawn', x: 7, y: 2},
        {type: 'Pawn', x: 8, y: 2},
        {type: 'Rook', x: 1, y: 1},
        {type: 'Knight', x: 2, y: 1},
        {type: 'Bishop', x: 3, y: 1},
        {type: 'King', x: 4, y: 1},
        {type: 'Queen', x: 5, y: 1},
        {type: 'Bishop', x: 6, y: 1},
        {type: 'Knight', x: 7, y: 1},
        {type: 'Rook', x: 8, y: 1} ]

      piece_locations.each do | location |
        expect(game.pieces.white_pieces.exists?(location)).to eq(true)
      end
    end

    it 'verifies that black pieces are in the correct locations' do
      game = FactoryBot.create(:game)
      piece_locations = [{type: 'Pawn', x: 1, y: 7},
        {type: 'Pawn', x: 2, y: 7},
        {type: 'Pawn', x: 3, y: 7},
        {type: 'Pawn', x: 4, y: 7},
        {type: 'Pawn', x: 5, y: 7},
        {type: 'Pawn', x: 6, y: 7},
        {type: 'Pawn', x: 7, y: 7},
        {type: 'Pawn', x: 8, y: 7},
        {type: 'Rook', x: 1, y: 8},
        {type: 'Knight', x: 2, y: 8},
        {type: 'Bishop', x: 3, y: 8},
        {type: 'King', x: 4, y: 8},
        {type: 'Queen', x: 5, y: 8},
        {type: 'Bishop', x: 6, y: 8},
        {type: 'Knight', x: 7, y: 8},
        {type: 'Rook', x: 8, y: 8} ]

      piece_locations.each do | location |
        expect(game.pieces.black_pieces.exists?(location)).to eq(true)
      end
    end


  end

  describe 'board' do
    it '#square_occupied? returns true if coordinate is occupied' do
      game = FactoryBot.create(:game)
      piece = FactoryBot.create(:piece, game_id: game.id)
      result = game.square_occupied?(1, 1)
      expect(result).to eq true
    end

    it '#square_occupied? returns false if coordinate is not occupied' do
      game = FactoryBot.build(:game)
      result = game.square_occupied?(2, 3)
      expect(result).to eq false
    end
  end
<<<<<<< HEAD
  describe 'game states' do 
    context "when game is first created" do
      it "should be pending" do
        game=FactoryBot.create :game 
        expect(game.state).to eq("pending")
      end
=======


  describe 'available' do
    let(:game) {FactoryBot.create :game}

    xit 'should show available games, which are games with total_players = 1' do
      result = Game.available.count
      expect(result).to eq(1)
    end
  end
  
  describe 'players' do
    it 'should initialize current user as white player' do
      game = FactoryBot.create(:game)
      expect(game.white_player_id).to eq game.user_id

>>>>>>> f350a91f581278352d05ced19821cec969ba23ea
    end
    context "when black player joins" do
    it "should be white_turn" do
        game=FactoryBot.create :game 
        game.black_player=FactoryBot.create :user 
        game.save 
        expect(game.state).to eq("white_turn")
      end
    end 
    
  end
end

