Rails.application.routes.draw do
  devise_for :users

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  root 'home#index'

  namespace :my_fifa do
    resources :players, except: [:show, :edit, :destroy] do
      collection {
        post 'update_json'
        post 'import_csv'
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
  end
end
