Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root 'games#new'
  resources :games, only: %i[new create]
  # Defines the root path route ("/")
  # root "articles#index"
end
