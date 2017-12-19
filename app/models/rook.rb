class Rook < Piece
  def is_rook_move_valid?(x_target, y_target)
    if !valid_move?(x_target, y_target)
      return false
    elsif !in_rook_range?(x_target, y_target)
      return false
    elsif is_obstructed?(x_target, y_target) 
      return false
    else
      return true
    end
  end

  def move_action(x_target, y_target)
    if is_rook_move_valid?(x_target, y_target)
      self.x = x_target
      self.y = y_target
    else
      # return error message
    end

  end

  private

  def in_rook_range?(x_target, y_target)
    if horizontal_move?(x_target, y_target)
      return true
    elsif vertical_move?(x_target, y_target)
      return true
    else
      return false
    end
  end
end
