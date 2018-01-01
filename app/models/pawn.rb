class Pawn < Piece

  #need to add logic concerning checking target for vertical moves(non-capturable)
  private

  def in_range?(x_target, y_target)
    case self.color
    when 'white'
      case self.y
      when 2 # starting position for white piece
        if vertical_move?(x_target, y_target) && y_target > self.y && ((y_target - self.y).abs == 1 || (y_target - self.y).abs == 2)
          return true
        else
          return false
        end
      else
        if vertical_move?(x_target, y_target) && y_target > self.y && (y_target - self.y).abs == 1
          return true
        else
          return false
        end
      end
    when 'black'
      case self.y
      when 7 # starting position for black piece
        if vertical_move?(x_target, y_target) && y_target < self.y && ((y_target - self.y).abs == 1 || (y_target - self.y).abs == 2)
          return true
        else
          return false
        end
      else
        if vertical_move?(x_target, y_target) && y_target < self.y && (y_target - self.y).abs == 1
          return true
        else
          return false
        end
      end
    end
  end
end
