Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  root 'home#index'

  namespace :my_fifa do
    resources :players, except: [:destroy] do
      collection {
        post 'search'
        post 'update_json'
        post 'import_csv'
      }
      member {
        post 'set_status'
        post 'sign_new_contract'
        post 'exit'
        post 'rejoin'
      }
    end
    resources :teams do
      member {
        post 'set_active'
      }
    end
    resources :matches do
      collection {
        post 'check_log'
      }
    end
    resources :seasons, except: [:new] do
      collection {
        get 'competitions_json'
      }
      member {
        get 'competitions'
      }
    end

    resources :competitions

    resources :player_seasons, only: [:update]
    resources :squads, except: [:edit] do
      member {
        get 'info'
      }
    end
    resources :formations do
      member {
        post 'set_active'
      }
    end
  end
end
