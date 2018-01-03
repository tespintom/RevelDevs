class PiecesController < ApplicationController
  before_action :authenticate_user!

  def show
    @piece = Piece.find_by_id(params[:id])
    if @piece.blank?
      return render_not_found
    else
      render json: @piece
    end
  end

  def update
  end

  private

  def render_not_found(status=:not_found)
    render plain: "#{status.to_s.titleize} :(", status: status
  end
end
