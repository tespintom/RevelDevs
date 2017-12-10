class Game < ApplicationRecord
  has_many :pieces

  #we need this for everything else to work
  def square_occupied?(x, y)
    if pieces.active.where(x:, y:).any?
      return true
    else
      return false
    end
  end
end
