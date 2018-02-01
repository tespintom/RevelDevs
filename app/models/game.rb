class Game < ApplicationRecord
  has_many :pieces
  has_many :players
  belongs_to :user
  before_save :start_game_when_black_player_is_added
  after_create :populate

  scope :available, -> { where(state: "pending") }
  scope :in_progress, -> { where(state: ["white_turn", "black_turn"]) }

  before_create :current_user_is_white_player

  def square_occupied?(x_current, y_current)
    pieces.active.where({x: x_current, y: y_current}).any? ? true : false
  end

  def add_black_player!(user)
    self.black_player_id = user.id
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

  def is_player_turn?(user)
    if self.state == "white_turn" && user.id == white_player_id
      true
    elsif self.state == "black_turn" && user.id == black_player_id
      true
    else
      false
    end
  end

  def player_turn
    if self.state == "white_turn"
      self.state = "black_turn"
      save
    elsif self.state == "black_turn"
      self.state = "white_turn"
      save
    end
  end

  def in_check?(color)
    @piece_causing_check = []
    king = pieces.find_by(type: 'King', color: color)
    enemy_pieces(color).each do |piece|
       if piece.is_capturable?(king.x, king.y)
         @piece_causing_check = piece
         return true
       end
    end
    false
  end

  def checkmate?(color)
    king = pieces.find_by(type: 'King', color: color)
    return false unless in_check?(color)
    return false if @piece_causing_check.can_be_captured?(color)
    return false if king.move_out_of_check?(color)
    return false if @piece_causing_check.can_be_blocked?(king)
    true
  end

  def move_out_of_check?(color)
    king = pieces.find_by(type: 'King', color: color)
    old_x = king.x
    old_y = king.y
    ((king.x - 1)..(king.x + 1)).each do |x_target|
      ((king.y - 1)..(king.y + 1)).each do |y_target|
        piece_to_be_captured = pieces.active.find_by({x: x_target, y: y_target} )
        if king.attempt_move(x_target, y_target)
          king.update_attributes(x: old_x, y: old_y)
          if piece_to_be_captured
            piece_to_be_captured.update_attributes(captured: false, x: x_target, y: y_target)
          end
          return true
        end
      end
    end
    false
  end


  def enemy_pieces(color)
    pieces.select { |piece| piece.color != color && piece.captured != true }
  end

  def pieces_remaining(color)
    pieces.includes(:game).where(
     "color = ? and state != 'off-board'",
     color).to_a
  end

  def my_pieces(color)
    pieces.select { |piece| piece.color = color && piece.captured != true }
  end

  def capture_opponent_causing_check?(color)
      friend_pieces = my_pieces(color)
      my_piece_that_can_capture_opponent = []
      friend_pieces.each do |friend|
        @enemies_causing_check.each do |enemy|
          my_piece_that_can_capture_opponent << friend if friend.is_capturable?(enemy.x_position, enemy.y_position) == true
      end
    end
    return true if my_piece_that_can_capture_opponent.any?
    false
  end

  def can_be_blocked?(color)
    friend_pieces = my_pieces(color)
  end


  private

  def start_game_when_black_player_is_added
    self.state = "white_turn" if state == "pending" && black_player_id.present?
  end

  def populate
    (1..8).each do |piece|
      pieces.create(x: piece, y: 2, color: 'white', type: 'Pawn', icon: '#9817')
      pieces.create(x: piece, y: 7, color: 'black', type: 'Pawn', icon: '#9823')
    end

    # ["Rook", "Knight", "Bishop", "King", "Queen", "Bishop", "Knight", "Rook"].each.with_index(1) do |klass, index|
    #   pieces.create(x: index, y: 1, color: 'white', type: klass)
    #   pieces.create(x: index, y: 8, color: 'black', type: klass)
    # end

    pieces.create(x: 1, y: 1, color: 'white', type: 'Rook', icon: '#9814')
    pieces.create(x: 2, y: 1, color: 'white', type: 'Knight', icon: '#9816')
    pieces.create(x: 3, y: 1, color: 'white', type: 'Bishop', icon: '#9815')
    pieces.create(x: 4, y: 1, color: 'white', type: 'King', icon: '#9812')
    pieces.create(x: 5, y: 1, color: 'white', type: 'Queen', icon: '#9813')
    pieces.create(x: 6, y: 1, color: 'white', type: 'Bishop', icon: '#9815')
    pieces.create(x: 7, y: 1, color: 'white', type: 'Knight', icon: '#9816')
    pieces.create(x: 8, y: 1, color: 'white', type: 'Rook', icon: '#9814')
    pieces.create(x: 1, y: 8, color: 'black', type: 'Rook', icon: '#9820')
    pieces.create(x: 2, y: 8, color: 'black', type: 'Knight', icon: '#9822')
    pieces.create(x: 3, y: 8, color: 'black', type: 'Bishop', icon: '#9821')
    pieces.create(x: 4, y: 8, color: 'black', type: 'King', icon: '#9818')
    pieces.create(x: 5, y: 8, color: 'black', type: 'Queen', icon: '#9819')
    pieces.create(x: 6, y: 8, color: 'black', type: 'Bishop', icon: '#9821')
    pieces.create(x: 7, y: 8, color: 'black', type: 'Knight', icon: '#9822')
    pieces.create(x: 8, y: 8, color: 'black', type: 'Rook', icon: '#9820')
  end

end
