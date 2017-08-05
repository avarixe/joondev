Cmsk::Engine.routes.draw do
  resources :players, except: [:show, :edit, :destroy] do
    collection do
      post 'update_json'
      post 'import_csv'
    end
  end
  resources :teams
  resources :games
  resources :competitions
  resources :fixtures, only: [:update]
  resources :squads, except: [:except, :destroy] do
    member do 
      get 'players_json'
    end
  end
  resources :analytics, only: [:index] do
    collection do
      get 'players'
    end
  end
  root 'teams#index'
end
