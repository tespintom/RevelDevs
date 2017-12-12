class Game < ApplicationRecord
  has_many :pieces
  scope :available, -> {where("total_players = 1")}
  #we need this for everything else to work
  def square_occupied?(x, y)
    if pieces.active.where({x: x, y: y}).any?
      return true
    else
      return false
    end
  end

end
