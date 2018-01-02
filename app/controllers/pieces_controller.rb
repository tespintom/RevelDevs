class PiecesController < ApplicationController
  before_action :authenticate_user!

  def show
    @piece = Piece.find_by_id(params[:id])
    render json: @piece
    # @game = @piece.game
    # redirect_to game_path(@game)
    return render_not_found if @piece.blank?
  end

  def update
  end

  private

  def render_not_found(status=:not_found)
    render plain: "#{status.to_s.titleize} :(", status: status
  end
end
