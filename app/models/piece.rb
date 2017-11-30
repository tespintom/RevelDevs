class Piece < ApplicationRecord
  has_many :moves
  has_one :starting_position
  has_one :current_position

  #determines if space is occupied by an active piece
  def is_obstructed?(x,y)
  end

  #first x square to be checked for blockage
  def x_first(x)
  end

  #last x square to be checked for blockage
  def x_last(x)
  end

  #first y square to be checked for blockage
  def y_first(y)
  end

  #last y square to be checked for blockage
  def y_last(y)
  end

  #determines if the move is horizontal
  def horizontal_move?(x, y)
  end

  #determines if the move is vertical
  def vertical_move?(x,y)
  end

  #determines if the move is diagonal
  def diagonal_move?(x,y)
  end

  #determines if the move is valid/possible
  def valid_move?(x,y)
  end
end
