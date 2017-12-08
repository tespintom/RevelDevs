class Game < ApplicationRecord
  has_many :pieces

  def square_occupied?(x, y)
  end
end
