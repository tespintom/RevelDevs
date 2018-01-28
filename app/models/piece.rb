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
     Piece.transaction do
       fail ActiveRecord::Rollback if game.check?(color)
     end
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
    self.x = x_target
    self.y = y_target
    self.is_promotable?
    true
  end

  def is_move_valid?(x_target, y_target)
    if !valid_move?(x_target, y_target)
      return false
    elsif !in_range?(x_target, y_target)
      return false
    elsif is_obstructed?(x_target, y_target)
      return false
    # elsif move_causes_check?(x_target, y_target)
    #   return false
    else
      return true
    end
  end

  #determines if space is occupied by an active piece
  #This ONLY checks if the PATH is obstructed, doesn't check if target is capturable.
  def is_obstructed?(x_target, y_target)
    return false if (x_target - self.x).abs <= 1 && (y_target - self.y).abs <= 1
    return true if is_obstructed_horizontal?(x_target, y_target)
    return true if is_obstructed_vertical?(x_target, y_target)
    return true if is_obstructed_diagonal?(x_target, y_target)
    return false
  end

  def is_obstructed_horizontal?(x_target, y_target)
    if horizontal_move?(x_target, y_target)
      if x_target > self.x
        ((self.x + 1)...x_target).each do |i|
          if game.square_occupied?(i, self.y)
            return true
          end
        end
      else
        ((x_target + 1)...self.x).each do |i|
          if game.square_occupied?(i, self.y)
            return true
          end
        end
      end
      false
    end
  end

  def is_obstructed_vertical?(x_target, y_target)
    if vertical_move?(x_target, y_target)
      if y_target > self.y
        ((self.y + 1)...y_target).each do |i|
          if game.square_occupied?(self.x, i)
            return true
          end
        end
      else
        ((y_target + 1)...self.y).each do |i|
          if game.square_occupied?(self.x, i)
            return true
          end
        end
      end
      false
    end
  end

  def is_obstructed_diagonal?(x_target, y_target)
    if diagonal_move?(x_target, y_target)
      if x_target > self.x
        start_x = self.x
        finish_x = x_target
      else
        start_x = x_target
        finish_x = self.x
      end
      if y_target > self.y
        start_y = self.y
        finish_y = y_target
      else
        start_y = y_target
        finish_y = self.y
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
  def horizontal_move?(x_target, y_target)
    if (x_target - self.x).abs > 0 && (y_target - self.y).abs ==  0
      return true
    else
      return false
    end
  end

  #determines if the move is vertical
  def vertical_move?(x_target, y_target)
    if (x_target - self.x).abs == 0 && (y_target - self.y).abs > 0
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
    if is_capturable?(x_target, y_target)
      target_piece(x_target, y_target).update_attributes(captured: true, x: 0, y: 0)
      move_action(x_target, y_target)
    end
  end

  def target_piece(x_target, y_target)
    game.pieces.active.find_by({x: x_target, y: y_target})
  end

  def is_promotable?
  end

  def can_castle?(x_target, y_target)
  end







  private

  def in_bounds?(x_target, y_target)
    (1..8).include?(x_target) && (1..8).include?(y_target)
  end

  def in_range?(x_target, y_target)
    true
  end
end
