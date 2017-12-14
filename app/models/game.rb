class Game < ApplicationRecord
  has_many :pieces
  has_many :players
  scope :available, -> {where("total_players = 1")}
  after_create :current_user_is_white_player
  #to initialize each game with the white_player as the user who created the game 
  #white_player_id needs to exist in the database
  
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
