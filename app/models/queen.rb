class Queen < Piece
  
  private

  def in_range?(x_target, y_target)
    if horizontal_move?(x_target, y_target)
      return true
    elsif vertical_move?(x_target, y_target)
      return true
    elsif diagonal_move?(x_target, y_target)
      return true
    else
      return false
    end
  end
end
