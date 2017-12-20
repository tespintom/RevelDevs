class GamesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def index
    @games = Game.all
    @available_games = Game.available
  end

  def new
    @game = Game.new
  end

  def create
    @game = current_user.games.create(game_params)
    redirect_to game_path(@game)
  end

  def show
    @game = Game.find_by_id(params[:id])
    render "Not found :(" if @game.blank?
  end

  def join
    current_game.add_black_player!(current_user)
    redirect_to game_path(current_game)
  end

  private

  def game_params
    params.require(:game).permit(:name, :white_player_id, :black_player_id, finished: false)
  end

  def current_game
    @game ||= Game.find_by_id(params[:id])
  end

end
