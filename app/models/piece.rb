class Piece < ApplicationRecord
  belongs_to :game
  validates :x, numericality: true
  validates :y, numericality: true

  scope :black_pieces, ->() { where(color: 'black') }
  scope :white_pieces, ->() { where(color: 'white') }
  scope :active, -> { where(captured: false) }


  def white?
    color == 'white'
  end

  def black?
    color == 'black'
  end

  def piece_color_matches_user_color?(user)
    if color == 'white' && user.id == game.white_player_id
      true
    elsif color == 'black' && user.id == game.black_player_id
      true
    else
      false
    end
  end

  def attempt_move(x_target, y_target)
    if can_castle?(x_target, y_target)
      castle!(x_target, y_target)
    elsif is_capturable?(x_target, y_target)
      captured!(x_target, y_target)
    elsif !game.square_occupied?(x_target, y_target) && is_move_valid?(x_target, y_target)
      move_action(x_target, y_target)
    else
      false
    end
  end

  def move_action(x_target, y_target)
    old_x = self.x
    old_y = self.y
    old_icon = self.icon
    old_type = self.type
    self.update_attributes(x: x_target, y: y_target)
    self.is_promotable?
    if game.in_check?(self.color)
      self.update_attributes(x: old_x, y: old_y, icon: old_icon, type: old_type)
      return false
    end
    true
  end

  def is_move_valid?(x_target, y_target)
    if !valid_move?(x_target, y_target)
      return false
    elsif !in_range?(x_target, y_target)
      return false
    elsif is_obstructed?(x_target, y_target)
      return false
    else
      return true
    end
  end

  #determines if space is occupied by an active piece
  #This ONLY checks if the PATH is obstructed, doesn't check if target is capturable.
  def is_obstructed?(x_target, y_target, piece_x = self.x, piece_y = self.y)
    return false if (x_target - piece_x).abs <= 1 && (y_target - piece_y).abs <= 1
    return true if is_obstructed_horizontal?(x_target, y_target, piece_x, piece_y)
    return true if is_obstructed_vertical?(x_target, y_target, piece_x, piece_y)
    return true if is_obstructed_diagonal?(x_target, y_target, piece_x, piece_y)
    return false
  end

  def is_obstructed_horizontal?(x_target, y_target, piece_x = self.x, piece_y = self.y)
    if horizontal_move?(x_target, y_target, piece_x, piece_y)
      if x_target > piece_x
        ((piece_x + 1)...x_target).each do |i|
          if game.square_occupied?(i, piece_y)
            return true
          end
        end
      else
        ((x_target + 1)...piece_x).each do |i|
          if game.square_occupied?(i, piece_y)
            return true
          end
        end
      end
      false
    end
  end

  def is_obstructed_vertical?(x_target, y_target, piece_x = self.x, piece_y = self.y)
    if vertical_move?(x_target, y_target, piece_x, piece_y)
      if y_target > piece_y
        ((piece_y + 1)...y_target).each do |i|
          if game.square_occupied?(piece_x, i)
            return true
          end
        end
      else
        ((y_target + 1)...piece_y).each do |i|
          if game.square_occupied?(piece_x, i)
            return true
          end
        end
      end
      false
    end
  end

  def is_obstructed_diagonal?(x_target, y_target, piece_x = self.x, piece_y = self.y)
    if diagonal_move?(x_target, y_target, piece_x, piece_y)
      if x_target > piece_x
        start_x = piece_x
        finish_x = x_target
      else
        start_x = x_target
        finish_x = piece_x
      end
      if y_target > piece_y
        start_y = piece_y
        finish_y = y_target
      else
        start_y = y_target
        finish_y = piece_y
      end
      ((start_x + 1)...finish_x).each do |h|
        ((start_y + 1)...finish_y).each do |v|
          if diagonal_move?(x_target, y_target, h, v)
            if game.square_occupied?(h, v)
              return true
            end
          end
        end
      end
      false
    end
  end

  #determines if the move is horizontal
  def horizontal_move?(x_target, y_target, piece_x = self.x, piece_y = self.y)
    if (x_target - piece_x).abs > 0 && (y_target - piece_y).abs ==  0
      return true
    else
      return false
    end
  end

  #determines if the move is vertical
  def vertical_move?(x_target, y_target, piece_x = self.x, piece_y = self.y)
    if (x_target - piece_x).abs == 0 && (y_target - piece_y).abs > 0
      return true
    else
      return false
    end
  end

  #determines if the move is diagonal
  def diagonal_move?(x_target, y_target, x_current=self.x, y_current=self.y)
    if (x_target - x_current).abs == (y_target - y_current).abs
      return true
    else
      return false
    end
  end

  #determines if the move is valid/possible
  def valid_move?(x_target, y_target)
    in_bounds?(x_target, y_target)
  end

  def is_capturable?(x_target, y_target)
    if game.square_occupied?(x_target, y_target) && self.color != target_piece(x_target, y_target).color
      return is_move_valid?(x_target, y_target) ? true : false
    else
      false
    end
  end

  def captured!(x_target, y_target)
    piece_to_be_captured = target_piece(x_target, y_target)
    piece_to_be_captured.update_attributes(captured: true, x: 0, y: 0) if move_action(x_target, y_target)
  end

  def target_piece(x_target, y_target)
    game.pieces.active.find_by({x: x_target, y: y_target})
  end

  def is_promotable?
  end

  def can_castle?(x_target, y_target)
  end

  def castle!(x_target, y_target)
  end

  def find_corner_piece(x_target, y_target)
  end

  # def capture_opponent_causing_check?(color)
  #   opponents = game.enemy_pieces(color)
  #   opponents.each do |opponent|
  #     return true if opponent.is_capturable?(x, y)
  #   end
  #   false
  # end

  private

  def in_bounds?(x_target, y_target)
    (1..8).include?(x_target) && (1..8).include?(y_target)
  end

  def in_range?(x_target, y_target)
    true
  end
end
