class GameBoard < ApplicationRecord
  belongs_to :game
  has_many :pieces

  def populate
    populate_boundary_pieces(row: 0, color: 'white')
    populate_interior_pieces(row: 1, color: 'white')
    populate_empty_spaces
    populate_interior_pieces(row: 6, color: 'black')
    populate_boundary_pieces(row: 7, color: 'black')
  end

  private

  def populate_boundary_pieces(row:, color:)
    [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook].each_with_index do | klass, index |
      piece = klass.create(game_board_id: self.id, color: color, x_position: row, y_position: index)
      squares << piece.id
    end
    save!
  end

  def populate_interior_pieces(row:, color:)
    8.times do | index |
      piece = Pawn.create(game_board_id: self.id, color: color, x_position: row, y_position: index)
      squares << piece.id
    end
    save!
  end

  def populate_empty_spaces
    32.times do
      squares << nil
    end
    save!
  end
end
