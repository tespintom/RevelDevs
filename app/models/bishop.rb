class Bishop < Piece

  private

  def in_range?(x_target, y_target)
    if diagonal_move?(x_target, y_target)
      return true
    else
      return false
    end
  end
  
end
