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
        {type: 'Queen', x: 4, y: 1, icon: '#9813' },
        {type: 'King', x: 5, y: 1, icon: '#9812' },
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
        {type: 'Queen', x: 4, y: 8, icon: '#9819'},
        {type: 'King', x: 5, y: 8, icon: '#9818'},
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

    it "should update total_players to 2 if black and white players are different users" do
      game = FactoryBot.create(:game)
      new_user = FactoryBot.create(:user)
      game.add_black_player!(new_user)
      expect(game.total_players).to eq(2)
      expect(game.black_player_id).to eq(new_user.id)
    end

    it "should not update total_players if black and white players are the same" do
      game = FactoryBot.create(:game)
      user = game.user
      game.add_black_player!(game.user)
      expect(game.total_players).to eq(1)
      expect(game.black_player_id).to eq(nil)
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
    it 'should return true if King is in check' do
      game = FactoryBot.create(:game)
      queen = game.pieces.active.find_by({x: 4, y: 1})
      queen.update(color: 'black')
      queen.reload
      king = game.pieces.active.find_by({x: 5, y: 1})
      expect(game.in_check?(king.color)).to eq true
    end

    it 'should return true if King is in check from a Knight' do
      game = FactoryBot.create(:game)
      piece = FactoryBot.build(:piece, game_id: game.id)
      knight = game.pieces.active.find_by({x: 2, y: 8})
      knight.update_attributes(x: 4, y: 3)
      knight.reload
      king = game.pieces.active.find_by({x: 5, y: 1})
      expect(game.in_check?(king.color)).to eq true
    end

    it 'should return false if King is not in check' do
      game = FactoryBot.create(:game)
      king = game.pieces.active.find_by({x: 5, y: 1})
      expect(game.in_check?(king.color)).to eq false
    end
  end

  describe 'move out of check' do
    it 'should return true if the King can move out of check' do
      game = FactoryBot.create(:game)
      queen = game.pieces.active.find_by({x: 4, y: 8})
      king = game.pieces.active.find_by({x: 5, y: 1})
      queen.update_attributes(x: 5, y: 4)
      pawn = game.pieces.active.find_by({x: 5, y: 2})
      pawn.update_attributes(captured: true, x: 0, y: 0)
      king.update_attributes(x: 5, y: 2)
      expect(game.in_check?(king.color)).to eq true
      pawn2 = game.pieces.active.find_by({x: 4, y: 2})
      pawn2.update_attributes(captured: true, x: 0, y: 0)
      expect(game.move_out_of_check?(king.color)).to eq true
    end

    it 'should return false if the King can not move out of check' do
      game = FactoryBot.create(:game)
      queen = game.pieces.active.find_by({x: 4, y: 8})
      king = game.pieces.active.find_by({x: 5, y: 1})
      queen.update_attributes(x: 5, y: 4)
      pawn = game.pieces.active.find_by({x: 5, y: 2})
      pawn.update_attributes(captured: true, x: 0, y: 0)
      king.update_attributes(x: 5, y: 2)
      expect(game.in_check?(king.color)).to eq true
      expect(game.move_out_of_check?(king.color)).to eq false
    end

    it 'should return true if the King can capture a piece to move out of check' do
      game = FactoryBot.create(:game)
      queen = game.pieces.active.find_by({x: 4, y: 8})
      king = game.pieces.active.find_by({x: 5, y: 1})
      queen.update_attributes(x: 5, y: 4)
      pawn = game.pieces.active.find_by({x: 5, y: 2})
      pawn2 = game.pieces.active.find_by({x: 4, y: 2})
      pawn.update_attributes(captured: true, x: 0, y: 0)
      pawn2.update_attributes(color: 'black')
      king.update_attributes(x: 5, y: 2)
      expect(game.in_check?(king.color)).to eq true
      expect(game.move_out_of_check?(king.color)).to eq true
    end
  end

  describe 'capture opponent causing check' do
    it 'should be able to capture the piece causing check' do
      game = FactoryBot.create(:game)
      knight = game.pieces.active.find_by({x: 2, y: 8})
      queen = game.pieces.active.find_by({x: 4, y: 1})
      knight.update_attributes(x: 4, y: 3)
      knight.reload
      king = game.pieces.active.find_by({x: 5, y: 1})
      expect(game.in_check?(king.color)).to eq true
      queen.update_attributes(x: 5, y: 3)
      queen.reload
      expect(game.capture_opponent_causing_check?(king.color)).to eq true
    end

    it 'should not be possible to capture the piece causing check' do
      game = FactoryBot.create(:game)
      piece = FactoryBot.build(:piece, game_id: game.id)
      queen = game.pieces.active.find_by({x: 4, y: 8})
      king = game.pieces.active.find_by({x: 5, y: 1})
      queen.update_attributes(x: 5, y: 4)
      pawn = game.pieces.active.find_by({x: 5, y: 2})
      pawn.update_attributes(captured: true, x: 0, y: 0)
      king.update_attributes(x: 5, y: 2)
      expect(game.in_check?(king.color)).to eq true
      expect(game.capture_opponent_causing_check?(king.color)).to eq false
    end
  end

  describe 'can be blocked' do
    it 'should return true if check path can be blocked' do 
      game = FactoryBot.create(:game)
      queen = game.pieces.active.find_by({x: 4, y: 8})
      rook = game.pieces.active.find_by({x: 1, y: 1})
      king = game.pieces.active.find_by({x: 5, y: 1})
      queen.update_attributes(x: 5, y: 4)
      pawn = game.pieces.active.find_by({x: 5, y: 2})
      pawn.update_attributes(captured: true, x: 0, y: 0)
      king.update_attributes(x: 5, y: 2)
      rook.update_attributes(x: 1, y: 3)
      expect(game.in_check?(king.color)).to eq true
      expect(game.can_be_blocked?(king)).to eq true
    end

    it 'should return false if check path can not be blocked' do
      game = FactoryBot.create(:game)
      queen = game.pieces.active.find_by({x: 4, y: 8})
      king = game.pieces.active.find_by({x: 5, y: 1})
      queen.update_attributes(x: 5, y: 4)
      pawn = game.pieces.active.find_by({x: 5, y: 2})
      pawn.update_attributes(captured: true, x: 0, y: 0)
      king.update_attributes(x: 5, y: 2)
      expect(game.in_check?(king.color)).to eq true
      expect(game.can_be_blocked?(king)).to eq false
    end
  end
  
  describe 'king to enemy path' do
    it 'should return the path of values between king and enemy' do
      game = FactoryBot.create(:game)
      queen = game.pieces.active.find_by({x: 4, y: 8})
      king = game.pieces.active.find_by({x: 5, y: 1})
      queen.update_attributes(x: 5, y: 4)
      pawn = game.pieces.active.find_by({x: 5, y: 2})
      pawn.update_attributes(captured: true, x: 0, y: 0)
      king.update_attributes(x: 5, y: 2)
      expect(game.king_to_enemy_path(king)).to eq [[5, 3]]
    end
    it 'should return the diagonal path of values between king and enemy' do
      game = FactoryBot.create(:game)
      queen = game.pieces.active.find_by({x: 4, y: 8})
      king = game.pieces.active.find_by({x: 5, y: 1})
      queen.update_attributes(x: 7, y: 4)
      pawn = game.pieces.active.find_by({x: 5, y: 2})
      pawn.update_attributes(captured: true, x: 0, y: 0)
      king.update_attributes(x: 5, y: 2)
      expect(game.king_to_enemy_path(king)).to eq [[6, 3]]
    end
  end

  describe 'checkmate' do
    it 'should return true if King is in checkmate' do
      game = FactoryBot.create(:game)
      queen = game.pieces.active.find_by({x: 4, y: 8})
      king = game.pieces.active.find_by({x: 5, y: 1})
      queen.update_attributes(x: 5, y: 4)
      pawn = game.pieces.active.find_by({x: 5, y: 2})
      pawn.update_attributes(captured: true, x: 0, y: 0)
      king.update_attributes(x: 5, y: 2)
      expect(game.checkmate?(king.color)).to eq true
    end

    it 'should return false if King is not in checkmate' do
      game = FactoryBot.create(:game)
      expect(game.checkmate?('white')).to eq false
    end

    it '#checkmate! should update the game state to "checkmate" and set finished to true' do
      game = FactoryBot.create(:game)
      game.checkmate!
      expect(game.state).to eq("checkmate")
      expect(game.finished).to eq(true)
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
