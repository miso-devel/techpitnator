Rails.application.routes.draw do
  root 'games#new'
  get 'games/test'
  resources :games, only: %i[new create] do
    member { get :give_up }
    resource :progresses, only: %i[new create]
  end
end
