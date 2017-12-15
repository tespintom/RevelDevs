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

  def coordinate(x, y)
    coordinate = [x, y]
  end

# dont worry about starting postiong
#
  #determines if space is occupied by an active piece
  def is_obstructed?(x_current, y_current, x_target, y_target)
    return true if is_obstructed_horizontal?(x_current, y_current, x_target, y_target)
    return true if is_obstructed_vertical?(x_current, y_current, x_target, y_target)
    return true if is_obstructed_diagonal?(x_current, y_current, x_target, y_target)
    return false
  end

  def is_obstructed_horizontal?(x_current, y_current, x_target, y_target)
    if horizontal_move?(x_current, y_current, x_target, y_target)
      if x_target > x_current
        ((x_current + 1)...x_target).each do |i|
          if game.square_occupied?(i, y_current)
            true
          end
        end
      else
        ((x_target + 1)...x_current).each do |i|
          if game.square_occupied?(i, y_current)
            true
          end
        end
      end
      # false
    end
  end

  def is_obstructed_vertical?(x_current, y_current, x_target, y_target)
    if vertical_move?(x_current, y_current, x_target, y_target)
      if y_target > y_current
        (y_current...y_target).each do |i|
          if game.square_occupied?(x_current, i)
            true
          end
        end
      else
        ((y_target + 1)...y_current).each do |i|
          if game.square_occupied?(x_current, i)
            true
          end
        end
      end
      # false
    end
  end

  def is_obstructed_diagonal?(x_current, y_current, x_target, y_target) 
    if diagonal_move?(x_current, y_current, x_target, y_target)
      if x_target > x_current
        start_x = x_current
        finish_x = x_target
      else
        start_x = x_target
        finish_x = x_current
      end
      if y_target > y_current
        start_y = y_current
        finish_y = y_target
      else
        start_y = y_target
        finish_y = y_current
      end
      ((start_x + 1)...finish_x).each do |h|
        ((start_y + 1)...finish_y).each do |v|
          if diagonal_move?(h, v, x_target, y_target)
            if game.square_occupied?(h, v)
              true
            end
          end
        end
      end
      # false
    end
  end



  #determines if the move is horizontal
  def horizontal_move?(x_current, y_current, x_target, y_target)
    if (x_target - x_current).abs > 0 && (y_target - y_current).abs ==  0
      return true
    else
      return false
    end
  end

  #determines if the move is vertical
  def vertical_move?(x_current, y_current, x_target, y_target)
    if (x_target - x_current).abs == 0 && (y_target - y_current).abs > 0
      return true
    else
      return false
    end
  end

  #determines if the move is diagonal
  def diagonal_move?(x_current, y_current, x_target, y_target)
    if (x_target - x_current).abs == (y_target - y_current).abs
      return true
    else
      return false
    end
  end

  #determines if the move is valid/possible
  def valid_move?(x_current, y_current, x_target, y_target)
    in_bounds?(x_target, y_target)
  end


  def in_bounds?(x_target, y_target)
    (1..8).include?(x_target) && (1..8).include?(y_target)
  end
end

