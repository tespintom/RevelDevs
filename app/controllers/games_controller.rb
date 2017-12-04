class GamesController < ApplicationController

  def index
    @games = Game.available
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.create(game_params)
  end

  def show
    @game = Game.find_by_id(params[:id])
    render "Not found :(" if game.blank?
  end

  private

  def game_params
    params.require(:game).permit(:name, :total_players, :result_id, :player_started_id)
  end
end
