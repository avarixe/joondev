Cmsk::Engine.routes.draw do
  resources :players, only: [:index, :new] do
    collection do
      post 'update_json'
    end
  end
  resources :teams
  resources :games
  resources :squads, only: [:index, :new, :show, :update, :create] do
    member do 
      get 'players_json'
    end
  end
  
  root 'teams#index'
end
