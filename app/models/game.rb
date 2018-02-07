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
    if user.id != self.white_player_id
      self.update_attributes(black_player_id: user.id, total_players: 2)
      # self.black_player_id = user.id
      # self.total_players = 2
      # save
    else
      false
    end
  end

  def current_user_is_white_player
    self.white_player_id = user_id
  end

  def game_end
    self.update(finished: true)
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

  def checkmate!
    self.update(state: "checkmate")
    game_end
  end

  def in_check?(color)
    @piece_causing_check = []
    king = pieces.find_by(type: 'King', color: color)
    x_position = king.x
    y_position = king.y
    enemy_pieces(color).each do |piece|
       if piece.is_capturable?(king.x, king.y)
         @piece_causing_check << piece
         return true
       end
    end
    false
  end

  def checkmate?(color)
    king = pieces.find_by(type: 'King', color: color)
    return false unless in_check?(color)
    return false if capture_opponent_causing_check?(color)
    return false if move_out_of_check?(king.color)
    return false if can_be_blocked?(king)
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

  def enemy_pieces_causing_check(color)
    @piece_causing_check = []
    king = pieces.find_by(type: 'King', color: color)
    x_position = king.x
    y_position = king.y
    enemy_pieces(color).each do |piece|
      if piece.is_capturable?(king.x, king.y)
        @piece_causing_check << piece
      end
    end
    @piece_causing_check
  end


  def my_pieces(color)
    pieces.select { |piece| piece.color == color && piece.captured == false && piece.type != 'King'}
  end

  def capture_opponent_causing_check?(color)
      friend_pieces = my_pieces(color)
      opponent_pieces = enemy_pieces_causing_check(color)
      friend_pieces.each do |friend|
        opponent_pieces.each do |enemy|
          return true if friend.is_capturable?(enemy.x, enemy.y)
        end
      end
    false
  end

  def can_be_blocked?(king)
    friend_pieces = my_pieces(king.color)
    opponent_pieces = enemy_pieces_causing_check(king.color)
    path_squares = king_to_enemy_path(king)
    friend_pieces.each do |friend|
      path_squares.each do |coordinate|
        return true if friend.is_move_valid?(coordinate[0], coordinate[1])
      end
    end
    false
  end

  def king_to_enemy_path(king)
    opponent_pieces = enemy_pieces_causing_check(king.color)
    path_squares = []
    opponent_pieces.each do |opponent|
      if opponent.horizontal_move?(king.x, king.y)
        if king.x > opponent.x 
          start_x = opponent.x
          finish_x = king.x
        else 
          start_x = king.x
          finish_x = opponent.x
        end
        ((start_x + 1)...finish_x).each do |x_position|
          path_squares << [x_position, opponent.y]
        end
      elsif opponent.vertical_move?(king.x, king.y)
        if king.y > opponent.y
          start_y = opponent.y
          finish_y = king.y
        else 
          start_y = king.y
          finish_y = opponent.y
        end
        ((start_y + 1)...finish_y).each do |y_position|
          path_squares << [opponent.x, y_position]
        end
      elsif opponent.diagonal_move?(king.x, king.y)
        if opponent.x > king.x
          start_x = king.x
          finish_x = opponent.x
        else
          start_x = opponent.x
          finish_x = king.x
        end
        if opponent.y > king.y
          start_y = king.y
          finish_y = opponent.y
        else
          start_y = opponent.y
          finish_y = king.y
        end
        ((start_x + 1)...finish_x).each do |h|
          ((start_y + 1)...finish_y).each do |v|
            if opponent.diagonal_move?(opponent.x, opponent.y, h, v)
              path_squares << [h, v]
            end
          end
        end
      end
    end
    path_squares
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
