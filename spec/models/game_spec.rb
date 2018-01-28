require 'rails_helper'

RSpec.describe Game, type: :model do
  describe '.new' do
    it 'is valid' do
      game = FactoryBot.create(:game)
      expect(game).to be_valid
    end

    it 'verifies that white pieces are in the correct locations' do
      game = FactoryBot.create(:game)
      piece_locations = [{type: 'Pawn', x: 1, y: 2, icon: '#9817'},
        {type: 'Pawn', x: 2, y: 2, icon: '#9817' },
        {type: 'Pawn', x: 3, y: 2, icon: '#9817' },
        {type: 'Pawn', x: 4, y: 2, icon: '#9817' },
        {type: 'Pawn', x: 5, y: 2, icon: '#9817' },
        {type: 'Pawn', x: 6, y: 2, icon: '#9817' },
        {type: 'Pawn', x: 7, y: 2, icon: '#9817' },
        {type: 'Pawn', x: 8, y: 2, icon: '#9817' },
        {type: 'Rook', x: 1, y: 1, icon: '#9814'},
        {type: 'Knight', x: 2, y: 1, icon: '#9816' },
        {type: 'Bishop', x: 3, y: 1, icon: '#9815' },
        {type: 'King', x: 4, y: 1, icon: '#9812' },
        {type: 'Queen', x: 5, y: 1, icon: '#9813' },
        {type: 'Bishop', x: 6, y: 1, icon: '#9815' },
        {type: 'Knight', x: 7, y: 1, icon: '#9816' },
        {type: 'Rook', x: 8, y: 1, icon: '#9814' } ]

      piece_locations.each do | location |
        expect(game.pieces.white_pieces.exists?(location)).to eq(true)
      end
    end

    it 'verifies that black pieces are in the correct locations' do
      game = FactoryBot.create(:game)
      piece_locations = [{type: 'Pawn', x: 1, y: 7, icon: '#9823'},
        {type: 'Pawn', x: 2, y: 7, icon: '#9823'},
        {type: 'Pawn', x: 3, y: 7, icon: '#9823'},
        {type: 'Pawn', x: 4, y: 7, icon: '#9823'},
        {type: 'Pawn', x: 5, y: 7, icon: '#9823'},
        {type: 'Pawn', x: 6, y: 7, icon: '#9823'},
        {type: 'Pawn', x: 7, y: 7, icon: '#9823'},
        {type: 'Pawn', x: 8, y: 7, icon: '#9823'},
        {type: 'Rook', x: 1, y: 8, icon: '#9820'},
        {type: 'Knight', x: 2, y: 8, icon: '#9822'},
        {type: 'Bishop', x: 3, y: 8, icon: '#9821'},
        {type: 'King', x: 4, y: 8, icon: '#9818'},
        {type: 'Queen', x: 5, y: 8, icon: '#9819'},
        {type: 'Bishop', x: 6, y: 8, icon: '#9821'},
        {type: 'Knight', x: 7, y: 8, icon: '#9822'},
        {type: 'Rook', x: 8, y: 8, icon: '#9820'} ]

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

  describe 'game states' do
    it "upon game creation the state should be pending" do
      game=FactoryBot.create :game
      expect(game.state).to eq("pending")
    end

    it "when black player joins, the game state should be white_turn" do
      game = FactoryBot.create(:game)
      new_user = FactoryBot.create(:user)
      game.black_player_id = new_user.id
      game.save
      expect(game.state).to eq("white_turn")
    end

    it "after a white player completes their turn, the game state should be black_turn" do
      game = FactoryBot.create(:game)
      new_user = FactoryBot.create(:user)
      game.black_player_id = new_user.id
      game.save
      game.player_turn
      game.reload
      expect(game.state).to eq("black_turn")
    end

    it "after a black player completes their turn, the game state should be white_turn" do
      game = FactoryBot.create(:game)
      new_user = FactoryBot.create(:user)
      game.black_player_id = new_user.id
      game.save
      game.player_turn
      game.player_turn
      expect(game.state).to eq("white_turn")
    end

    it "should return true if the state is 'white_turn' and the current user is the white player" do
      game = FactoryBot.create(:game)
      user = game.user
      game.state = "white_turn"
      result = game.is_player_turn?(user)
      expect(result).to eq true
    end

    it "should return true if the state is 'black_turn' and the current user is the black player" do
      game = FactoryBot.create(:game)
      new_user = FactoryBot.create(:user)
      game.black_player_id = new_user.id
      game.save
      game.player_turn
      result = game.is_player_turn?(new_user)
      expect(result).to eq true
    end

    it "should return false if it's not the player's turn" do
      game = FactoryBot.create(:game)
      new_user = FactoryBot.create(:user)
      game.black_player_id = new_user.id
      game.save
      result = game.is_player_turn?(new_user)
      expect(result).to eq false
    end
  end

  describe 'available' do
    it 'should show available games, which are games with total_players = 1' do
      game = FactoryBot.create(:game)
      result = Game.available.count
      expect(result).to eq(1)
    end
  end

  describe 'players' do
    it 'should initialize current user as white player' do
      game = FactoryBot.create(:game)
      expect(game.white_player_id).to eq game.user_id
    end

    it 'should verify there is no black player upon game creation' do
      game = FactoryBot.create(:game)
      expect(game.black_player_id).to eq nil
    end

    it "should update total_players to 2" do
      game = FactoryBot.create(:game)
      new_user = FactoryBot.create(:user)
      game.add_black_player!(new_user)
      expect(game.total_players).to eq(2)
    end
  end

  describe 'game end' do
    it 'should set finished to true on game end' do
      game = FactoryBot.create(:game)
      game.game_end
      expect(game.finished).to eq(true)
    end
  end

  describe 'check?' do
    it 'should return true if King is under check' do
      game = FactoryBot.create(:game)
      piece = FactoryBot.build(:piece, game_id: game.id)
      queen = game.pieces.active.find_by({x: 5, y: 1})
      king = game.pieces.active.find_by({x: 4, y: 1})
      expect(king.x).to eq(4)
      expect(king.y).to eq(1)
      expect(game.in_check?(king.color)).to eq true
    end
  end

  describe 'game draw' do
    it 'should return true if finished is true and winner id is nil' do
      game = FactoryBot.create(:game)
      game.game_end
      expect(game.draw).to eq(true)
    end
  end
end
