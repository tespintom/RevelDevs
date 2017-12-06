class GamesController < ApplicationController

  def index
    @games = Game.all
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.create(game_params)
    #@game.white? == current_user
    redirect_to game_path(@game)
  end

  def show
    @game = Game.find_by_id(params[:id])
    render "Not found :(" if @game.blank?
  end

  #def join
    #@game = Game.find_by_id(params[:id])
    #if @game.black_player == nil && current_user !@game.
  #end

  private

  def game_params
    params.require(:game).permit(:name)
  end
end
