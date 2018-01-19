class Game < ApplicationRecord
  has_many :pieces
  has_many :players
  belongs_to :user
  before_save :start_game_when_black_player_is_added
  after_create :populate

  scope :available, -> { where(state: "pending") }

  after_create :current_user_is_white_player


  # to initialize each game with the white_player as the user who created the game
  # white_player_id needs to exist in the database

  def square_occupied?(x_current, y_current)
    pieces.active.where({x: x_current, y: y_current}).any? ? true : false
  end

  def add_black_player!(player)
    self.black_player_id = player.id
    self.total_players = 2
    save
  end

  def current_user_is_white_player
    self.white_player_id = user_id
  end

  def game_end
    self.finished = true
  end

  def draw
    if self.finished == true && self.winner_id == nil
      return true
    else
      return false
    end
  end

  private

  def start_game_when_black_player_is_added
    self.state = "white_turn" if state == "pending" && black_player_id.present?
  end
  
  def player_turn
   #need to add state change for when the players turn changes.  
  end
  



  def populate
    (1..8).each do |piece|
      pieces.create(x: piece, y: 2, color: 'white', type: 'Pawn')
      pieces.create(x: piece, y: 7, color: 'black', type: 'Pawn')
    end

    ["Rook", "Knight", "Bishop", "King", "Queen", "Bishop", "Knight", "Rook"].each.with_index(1) do |klass, index|
      pieces.create(x: index, y: 1, color: 'white', type: klass)
      pieces.create(x: index, y: 8, color: 'black', type: klass)
    end
  end
end
