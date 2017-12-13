class Game < ApplicationRecord
  has_many :pieces
  has_many :players
  after_create :current_user_is_white_player

  #we need this for everything else to work
  def square_occupied?(x, y)
    if pieces.active.where({x: x, y: y}).any?
      return true
    else
      return false
    end
  end

  private

  def current_user_is_white_player
    white_player_id = current_user.id
  end
end
