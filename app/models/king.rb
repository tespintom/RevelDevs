class King < Piece
  def is_king_move_valid?(x_target, y_target)
    if !valid_move?(x_target, y_target)
      return false
    elsif !in_king_range?(x_target, y_target)
      return false
    elsif is_obstructed?(x_target, y_target) 
      return false
    else
      return true
    end
  end

  def move_action(x_target, y_target)
    if is_king_move_valid?(x_target, y_target)
      self.x = x_target
      self.y = y_target
    else
      # return error message
    end

  end

  private

  def in_range?(x_target, y_target)
    if (x_target - self.x).abs == 1 && horizontal_move?(x_target, y_target)
      return true
    elsif (y_target - self.y).abs == 1 && vertical_move?(x_target, y_target)
      return true
    elsif (x_target - self.x).abs == 1 && (y_target - self.y).abs == 1 && diagonal_move?(x_target, y_target)
      return true
    else
      return false
    end
  end
end
