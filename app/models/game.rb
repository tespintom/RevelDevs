class Game < ApplicationRecord
  has_many :pieces
  belongs_to :user
  cattr_accessor :current_user
  after_create :current_user_is_white_player, :populate

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
    self.white_player_id = self.user_id
  end

  def populate
    (1..8).each do |piece|
      self.pieces.create(x: piece, y: 1, color: "white", type: "Pawn")
    end

    (1..8).each do |piece|
      self.pieces.create(x: piece, y: 1, color: "black", type: "Pawn")
    end
  end

end
