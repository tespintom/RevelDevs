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
  def is_obstructed?(x, y, x_target, y_target)
    if horizontal_move?(x, y, x_target, y_target)
      (x...x_target).each do |x|
        if game.square_occupied?(x, y)
          return true
        else
          return false
        end
      end
    elsif vertical_move?(x, y, x_target, y_target)
      (y...y_target).each do |y|
        if game.square_occupied?(x, y)
          return true
        else
          return false
        end
      end 
    elsif diagonal_move?(x, y, x_target, y_target)
      (x...x_target).each do |x|
        (y...y_target). each do |y|
          if (x_target - x).abs == (y_target - y).abs && game.square_occupied?(x, y)
            return true
          else
            return false
          end
       end
     end
    end
  end 


  #determines if the move is horizontal
  def horizontal_move?(x, y, x_target, y_target)
    if (x_target - x).abs > 0 && (y_target - y).abs ==  0
      return true
    else
      return false
    end
  end

  #determines if the move is vertical
  def vertical_move?(x, y, x_target, y_target)
    if (x_target - x).abs == 0 && (y_target - y).abs > 0
      return true
    else
      return false
    end
  end

  #determines if the move is diagonal
  def diagonal_move?(x, y, x_target, y_target)
    if (x_target - x).abs == (y_target - y).abs
      return true
    else
      return false
    end
  end

  #determines if the move is valid/possible
  def valid_move?(x, y, x_target, y_target)
    in_bounds?(x_target, y_target)
  end


  def in_bounds?(x_target, y_target)
    (1..8).include?(x_target) && (1..8).include?(y_target)
  end
end
