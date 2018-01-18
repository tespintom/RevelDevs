class PiecesController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def show
    @piece = Piece.find_by_id(params[:id])
    if @piece.blank?
      return render_not_found
    # else
    #   #need to edit the database.
    #   #Single table inheritance uses the "type" field to connect the types of pieces to the pieces table.
    #   #need to add another field to store type or rename type field.
    #   render json: @piece
    end
    @game = @piece.game
    @pieces = @game.pieces.all
  end

  def update
    @piece = Piece.find_by_id(params[:id])
    @game = @piece.game
    x_target = piece_params[:x].to_i
    y_target = piece_params[:y].to_i
    if @piece.attempt_move(x_target, y_target)
      @piece.save
    else
      return render_not_found
    end
    render plain: "Success"
  end

  private

  def render_not_found(status=:not_found)
    render plain: "#{status.to_s.titleize} :(", status: status
  end

  def piece_params
    params.require(:piece).permit(:x, :y)
  end
end
