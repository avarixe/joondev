Rails.application.routes.draw do
  devise_for :users

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  root 'home#index'

  namespace :my_fifa do
    resources :players, except: [:destroy] do
      collection {
        post 'update_json'
        post 'import_csv'
      }
      member {
        post 'exit'
        post 'sign'
        get 'get_ovr'
      }
    end
    resources :teams
    resources :fixtures
    resources :seasons do
      member {
        get 'get_fixtures'
      }
    end
    resources :fixtures, only: [:update]
    resources :squads, except: [:edit, :destroy] do
      member {
        get 'players_json'
      }
    end
    resources :formations, except: [:destroy] do
    end
    resources :analytics, only: [:index] do
      collection {
        get 'players'
      }
    end
  end
end
