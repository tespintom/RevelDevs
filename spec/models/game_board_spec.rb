require 'rails_helper'

RSpec.describe GameBoard, type: :model do

describe '.new' do
  it 'is valid' do
    GameBoard = FactoryBot.create(:game_board)
    expect(GameBoard).to be_valid
  end
end

  it ' verfies the game board is populated with White Pieces ' do
    Game = Game.create()
    GameBoard = FactoryBot.create(:game_board)
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


      white_pieces = game.pieces.where(color: 'white').as_json(only: [:type, :color, :x, :y])

    piece_locations.each do | location |
      expect(white_pieces.include?(location)).to eq(true)
    end
  end

  it ' verfies the game board is populated with Black Pieces ' do
    Game = Game.create()
    GameBoard = FactoryBot.create(:game_board)
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


      white_pieces = game.pieces.where(color: 'black').as_json(only: [:type, :color, :x, :y])

    piece_locations.each do | location |
      expect(black_pieces.include?(location)).to eq(true)
    end
  end
end
