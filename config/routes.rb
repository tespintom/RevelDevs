Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :players
  root 'games#index'
  resources :games, only: [:new, :create, :show]
end
