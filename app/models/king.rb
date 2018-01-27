class King < Piece
  #Cannot castle if King is in check, or would castle into check
  #Cannot castle if the rook is under attack

  def castle!(x_target, y_target)
    rook = find_corner_piece(x_target, y_target)
    self.update_attributes(x: x_target, y: y_target)
    rook.x == 1 ? rook.update(x: x_target + 1) : rook.update(x: x_target - 1)
  end

  def can_castle?(x_target, y_target)
    if self.y == y_target && (self.x - x_target).abs == 2
      if in_original_position?
        corner_piece = find_corner_piece(x_target, y_target)
        if corner_piece
          return is_rook?(corner_piece) && in_original_position?(corner_piece) && !castling_obstructed?(corner_piece) ? true : false
        else
          return false
        end
      else
        return false
      end
    else
      false
    end
  end

  def castling_obstructed?(corner_piece)
    if self.x < corner_piece.x
      start_x = self.x
      finish_x = corner_piece.x
    else
      start_x = corner_piece.x
      finish_x = self.x
    end
    ((start_x + 1)...finish_x).each do |x_position|
      if game.square_occupied?(x_position, self.y)
        return true
      end
    end
    false
  end

  def in_original_position?(piece=self)
    piece.created_at == piece.updated_at ? true : false
  end

  def find_corner_piece(x_target, y_target)
    if self.x < x_target
      target_piece(8, y_target)
    else
      target_piece(1, y_target)
    end     
  end

  def is_rook?(piece)
    piece.type == "Rook" ? true : false
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


  def in_check?(x_target, y_target)
    if self.is_capturable(self.x_target, self.y_target)
      return true
    else
      return false
    end
  end
end
