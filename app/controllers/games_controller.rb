class GamesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :join, :show]

  def index
    @games = Game.all
    @available_games = @games.available.sort_by { |game| game.created_at }
    @in_progress_games = @games.in_progress.sort_by { |game| game.created_at }
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
    render_not_found if @game.blank?
  end

  def join
    if current_game.add_black_player!(current_user)
      redirect_to game_path(current_game)
    else
      redirect_to root_path
    end
  end

  private

  def game_params
    params.require(:game).permit(:name, :white_player_id, :black_player_id, finished: false, total_players: 1)
  end

  def current_game
    @game ||= Game.find_by_id(params[:id])
  end

  def render_not_found(status=:not_found)
    render plain: "#{status.to_s.titleize} :(", status: status
  end

end
