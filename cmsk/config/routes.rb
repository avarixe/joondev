Cmsk::Engine.routes.draw do
  resources :players, except: [:show, :edit, :destroy] do
    collection {
      post 'update_json'
      post 'import_csv'
    }
  end
  resources :teams
  resources :games
  resources :seasons do
    member {
      get 'get_fixtures'
    }
  end
  resources :fixtures, only: [:update]
  resources :squads, except: [:except, :destroy] do
    member {
      get 'players_json'
    }
  end
  resources :analytics, only: [:index] do
    collection {
      get 'players'
    }
  end
  root 'teams#index'
end
