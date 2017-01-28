Cmsk::Engine.routes.draw do
  resources :players, only: [:index, :new, :create] do
    collection do
      post 'update_json'
      post 'import_csv'
    end
  end
  resources :teams
  resources :games
  resources :squads, except: [:except, :destroy] do
    member do 
      get 'players_json'
    end
  end
  resources :analytics, only: [:index] do
    collection do
      match 'search', via: [:get, :post]
    end
  end
  root 'teams#index'
end
