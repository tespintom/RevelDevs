class Pawn < Piece

  #need to add logic concerning checking target for vertical moves(non-capturable)
  def is_pawn_move_valid?(x_target, y_target)
    if !valid_move?(x_target, y_target)
      return false
    elsif !in_pawn_range?(x_target, y_target)
      return false
    elsif is_obstructed?(x_target, y_target) # commented out until is_obstructed? working
      return false # commented out until is_obstructed? working
    else
      return true
    end
  end

  def move_action(x_target, y_target)
    if is_pawn_move_valid?(x_target, y_target)
      self.x = x_target
      self.y = y_target
    else
      # return error message
    end

  end

  private

  def in_pawn_range?(x_target, y_target)
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
