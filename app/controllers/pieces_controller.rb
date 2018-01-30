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
    if @piece.attempt_move(x_target, y_target)
      if @game.in_check?(@piece.color)
        return render_not_found
      else
        @piece.save
        @game.player_turn
      end
    else
      return render_not_found
    end
    # render json: { piece_type: @piece.type, piece_color: @piece.color }
    render json: { icon: @piece.icon }
    # render plain: "Success"
    # render json: @piece
  end

  private

  def render_not_found(status=:not_found)
    render plain: "#{status.to_s.titleize} :(", status: status
  end

  def piece_params
    params.require(:piece).permit(:x, :y)
  end
end
