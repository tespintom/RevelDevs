class Game < ApplicationRecord
  has_many :pieces
  has_many :players
  scope :available, -> {where("total_players = 1")}
  belongs_to :user
  after_create :current_user_is_white_player
  after_create :populate


  #to initialize each game with the white_player as the user who created the game 
  #white_player_id needs to exist in the database
  
  #we need this for everything else to work
  def square_occupied?(x_current, y_current)
    pieces.active.where({x: x_current, y: y_current}).any? ? true : false
  end

  private

  def current_user_is_white_player
    self.white_player_id = self.user_id
  end

  def populate
    (1..8).each do |piece|
      self.pieces.create(x: piece, y: 2, color: "white", type: "Pawn")
      self.pieces.create(x: piece, y: 7, color: "black", type: "Pawn")
    end

    [Rook, Knight, Bishop, King, Queen, Bishop, Knight, Rook].each.with_index(1) do | klass, index |
      self.pieces.create(x: index, y: 1, color: "white", type: klass)
      self.pieces.create(x: index, y: 8, color: "black", type: klass)
    end
  end

end
