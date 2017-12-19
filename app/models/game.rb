class Game < ApplicationRecord
  has_many :pieces
  belongs_to :white_player, class_name: "User" 
  belongs_to :black_player, class_name: "User", optional: true 
  before_save :start_game_when_black_player_is_added 
  scope :available, -> {where("total_players = 1")}
  after_create :populate



  #to initialize each game with the white_player as the user who created the game 
  #white_player_id needs to exist in the database
  
  #we need this for everything else to work
  def square_occupied?(x_current, y_current)
    pieces.active.where({x: x_current, y: y_current}).any? ? true : false
  end

  private
  
  def start_game_when_black_player_is_added
    self.state = "white_turn" if state == "pending" && black_player_id.present? 
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
