Rails.application.routes.draw do
  root 'games#new'
  get 'games/test'
  resources :games
end
