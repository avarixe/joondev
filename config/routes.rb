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
        post 'update_json'
        post 'import_csv'
      }
      member {
        post 'set_status'
        post 'sign_new_contract'
        post 'exit'
        post 'rejoin'
        get 'get_ovr'
      }
    end
    resources :teams do
      member {
        post 'set_active'
      }
    end
    resources :matches
    resources :seasons, except: [:new, :create]
    resources :squads, except: [:edit, :destroy] do
      member {
        get 'info'
      }
    end
    resources :formations, except: [:destroy] do
      member {
        post 'set_active'
      }
    end
    resources :analytics, only: [:index] do
      collection {
        get 'players'
      }
    end
  end
end
