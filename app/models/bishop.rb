class Bishop < Piece

  def is_bishop_move_valid?(x_target, y_target)
    if !valid_move?(x_target, y_target)
      return false
    elsif !in_bishop_range?(x_target, y_target)
      return false
    elsif is_obstructed?(x_target, y_target) 
      return false
    else
      return true
    end
  end

  def move_action(x_target, y_target)
    if is_bishop_move_valid?(x_target, y_target)
      self.x = x_target
      self.y = y_target
    else
      # return error message
    end

  end

  private

  def in_bishop_range?(x_target, y_target)
    if diagonal_move?(x_target, y_target)
      return true
    else
      return false
    end
  end
  
end
