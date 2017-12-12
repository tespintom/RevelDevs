class GamesController < ApplicationController

  def index
    @games = Game.all
    @available_games = Game.available
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.create(game_params)
    @game.add_player
    redirect_to game_path(@game)
  end

  def show
    @game = Game.find_by_id(params[:id])
    render "Not found :(" if @game.blank?
  end

  private

  def game_params
    params.require(:game).permit(:name)
  end
end
