class Game < ApplicationRecord
  has_many :pieces

  def square_occupied?(square)
    pieces.active.where(square).any?
  end
end
