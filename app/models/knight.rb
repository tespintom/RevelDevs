class Knight < Piece

  private

  def in_range?(x_target, y_target)
    if (x_target - self.x).abs == 2 && (y_target - self.y).abs == 1
      return true
    elsif (x_target - self.x).abs == 1 && (y_target - self.y).abs == 2
      return true
    else
      return false
    end
  end
end
