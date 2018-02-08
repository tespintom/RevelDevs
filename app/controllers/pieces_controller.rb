class PiecesController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def show
    @piece = Piece.find_by_id(params[:id])
    if @piece.blank?
      return render_not_found
    end
    @game = @piece.game
    if @piece.piece_color_matches_user_color?(current_user) && @game.is_player_turn?(current_user)
      return render plain: "Success"
    else
      render_not_found
    end
  end

  def update
    @piece = Piece.find_by_id(params[:id])
    @game = @piece.game
    x_target = piece_params[:x].to_i
    y_target = piece_params[:y].to_i
    rook = {}
    rook_before_x = ''
    rook_before_y = ''
    if @piece.can_castle?(x_target, y_target)
      rook = @piece.find_corner_piece(x_target, y_target)
      rook_before_x = rook.x
      rook_before_y = rook.y
    end
    if @piece.attempt_move(x_target, y_target)
      if @game.checkmate?(@piece.color == 'white' ? 'black' : 'white')
        @game.checkmate!
        return render json: {
          icon: @piece.icon,
          winner: @piece.color
        }
      else
        @game.player_turn
      end
    else
      return render_not_found
    end
    if rook != {}
      rook.reload
      rook_after_x = rook.x
      rook_after_y = rook.y
    end
    render json: { icon: @piece.icon,
      game_state: @game.state,
      rook_before_x: rook_before_x,
      rook_before_y: rook_before_y,
      rook_after_x: rook_after_x,
      rook_after_y: rook_after_y }
  end

  private

  def render_not_found(status=:not_found)
    render plain: "#{status.to_s.titleize} :(", status: status
  end

  def piece_params
    params.require(:piece).permit(:x, :y)
  end
end
