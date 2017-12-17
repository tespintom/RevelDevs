class King < Piece

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
