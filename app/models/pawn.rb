class Pawn < Piece

  def is_promotable?
    case self.color
    when 'white'
      if self.y == 8
        self.update_attributes(type: 'Queen', icon: '#9813')
      else
        false
      end
    when 'black'
      if self.y == 1
        self.update_attributes(type: 'Queen', icon: '#9819')
      else
        false
      end
    end
  end

  #need to add logic concerning checking target for vertical moves(non-capturable)
  private

  def in_range?(x_target, y_target)
    if in_capture_range?(x_target, y_target)
      true
    elsif !game.square_occupied?(x_target, y_target)
      case self.color
      when 'white'
        case self.y
        when 2 # starting position for white piece
          return vertical_move?(x_target, y_target) && y_target > self.y && ((y_target - self.y).abs == 1 || (y_target - self.y).abs == 2) ? true : false
        else
          return vertical_move?(x_target, y_target) && y_target > self.y && (y_target - self.y).abs == 1 ? true : false
        end
      when 'black'
        case self.y
        when 7 # starting position for black piece
          return vertical_move?(x_target, y_target) && y_target < self.y && ((y_target - self.y).abs == 1 || (y_target - self.y).abs == 2) ? true : false
        else
          return vertical_move?(x_target, y_target) && y_target < self.y && (y_target - self.y).abs == 1 ? true : false
        end
      end
    else
      false
    end
  end

  def in_capture_range?(x_target, y_target)
    if game.square_occupied?(x_target, y_target)
      case self.color
      when 'white'
        return (x_target - self.x).abs == 1 && (y_target - self.y) == 1 ? true : false
      when 'black'
        return (x_target - self.x).abs == 1 && (y_target - self.y) == -1 ? true : false
      end
    else
      false
    end
  end
end
