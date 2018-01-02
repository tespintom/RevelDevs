class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # before_action :set_current_user

  # def set_current_user
    # Game.current_user = current_user
  # end
end
