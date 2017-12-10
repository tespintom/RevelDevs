class King < Piece
  def is_king_move_valid?(x, y, x_target, y_target)
    if !valid_move?(x, y, x_target, y_target)
      return false
    elsif !in_king_range?(x, y, x_target, y_target)
      return false
    elsif is_obstructed?(x_target, y_target)
      return false
    else
      return true
    end
  end

  private

  def in_king_range?(x, y, x_target, y_target)
    if (x_target - x).abs == 1 && horizontal_move?(x, y, x_target, y_target)
      return true
    elsif (y_target - y).abs == 1 && vertical_move?(x, y, x_target, y_target)
      return true
    elsif (x_target - x).abs == 1 && (y_target - y).abs == 1 && diagonal_move?(x, y, x_target, y_target)
      return true
    else
      return false
    end
  end
end
