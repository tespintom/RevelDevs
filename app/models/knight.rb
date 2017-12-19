class Knight < Piece

  def is_knight_move_valid?(x_target, y_target)
    if !valid_move?(x_target, y_target)
      return false
    elsif !in_knight_range?(x_target, y_target)
      return false
    else
      return true
    end
  end

  def move_action(x_target, y_target)
    if is_knight_move_valid?(x_target, y_target)
      self.x = x_target
      self.y = y_target
    else
      # return error message
    end

  end

  private

  def in_knight_range?(x_target, y_target)
    if (x_target - self.x).abs == 2 && (y_target - self.y).abs == 1
      return true
    elsif (x_target - self.x).abs == 1 && (y_target - self.y).abs == 2
      return true
    else
      return false
    end
  end
end
