# == Route Map
#
#                            Prefix Verb   URI Pattern                                      Controller#Action
#                  new_user_session GET    /users/sign_in(.:format)                         users/sessions#new
#                      user_session POST   /users/sign_in(.:format)                         users/sessions#create
#              destroy_user_session DELETE /users/sign_out(.:format)                        users/sessions#destroy
#                     user_password POST   /users/password(.:format)                        devise/passwords#create
#                 new_user_password GET    /users/password/new(.:format)                    devise/passwords#new
#                edit_user_password GET    /users/password/edit(.:format)                   devise/passwords#edit
#                                   PATCH  /users/password(.:format)                        devise/passwords#update
#                                   PUT    /users/password(.:format)                        devise/passwords#update
#          cancel_user_registration GET    /users/cancel(.:format)                          users/registrations#cancel
#                 user_registration POST   /users(.:format)                                 users/registrations#create
#             new_user_registration GET    /users/sign_up(.:format)                         users/registrations#new
#            edit_user_registration GET    /users/edit(.:format)                            users/registrations#edit
#                                   PATCH  /users(.:format)                                 users/registrations#update
#                                   PUT    /users(.:format)                                 users/registrations#update
#                                   DELETE /users(.:format)                                 users/registrations#destroy
#                              root GET    /                                                home#index
#            search_my_fifa_players POST   /my_fifa/players/search(.:format)                my_fifa/players#search
#       update_json_my_fifa_players POST   /my_fifa/players/update_json(.:format)           my_fifa/players#update_json
#        import_csv_my_fifa_players POST   /my_fifa/players/import_csv(.:format)            my_fifa/players#import_csv
#         set_status_my_fifa_player POST   /my_fifa/players/:id/set_status(.:format)        my_fifa/players#set_status
#  sign_new_contract_my_fifa_player POST   /my_fifa/players/:id/sign_new_contract(.:format) my_fifa/players#sign_new_contract
#               exit_my_fifa_player POST   /my_fifa/players/:id/exit(.:format)              my_fifa/players#exit
#             rejoin_my_fifa_player POST   /my_fifa/players/:id/rejoin(.:format)            my_fifa/players#rejoin
#                   my_fifa_players GET    /my_fifa/players(.:format)                       my_fifa/players#index
#                                   POST   /my_fifa/players(.:format)                       my_fifa/players#create
#                new_my_fifa_player GET    /my_fifa/players/new(.:format)                   my_fifa/players#new
#               edit_my_fifa_player GET    /my_fifa/players/:id/edit(.:format)              my_fifa/players#edit
#                    my_fifa_player GET    /my_fifa/players/:id(.:format)                   my_fifa/players#show
#                                   PATCH  /my_fifa/players/:id(.:format)                   my_fifa/players#update
#                                   PUT    /my_fifa/players/:id(.:format)                   my_fifa/players#update
#           set_active_my_fifa_team POST   /my_fifa/teams/:id/set_active(.:format)          my_fifa/teams#set_active
#                     my_fifa_teams GET    /my_fifa/teams(.:format)                         my_fifa/teams#index
#                                   POST   /my_fifa/teams(.:format)                         my_fifa/teams#create
#                  new_my_fifa_team GET    /my_fifa/teams/new(.:format)                     my_fifa/teams#new
#                 edit_my_fifa_team GET    /my_fifa/teams/:id/edit(.:format)                my_fifa/teams#edit
#                      my_fifa_team GET    /my_fifa/teams/:id(.:format)                     my_fifa/teams#show
#                                   PATCH  /my_fifa/teams/:id(.:format)                     my_fifa/teams#update
#                                   PUT    /my_fifa/teams/:id(.:format)                     my_fifa/teams#update
#                                   DELETE /my_fifa/teams/:id(.:format)                     my_fifa/teams#destroy
#         check_log_my_fifa_matches POST   /my_fifa/matches/check_log(.:format)             my_fifa/matches#check_log
#                   my_fifa_matches GET    /my_fifa/matches(.:format)                       my_fifa/matches#index
#                                   POST   /my_fifa/matches(.:format)                       my_fifa/matches#create
#                 new_my_fifa_match GET    /my_fifa/matches/new(.:format)                   my_fifa/matches#new
#                edit_my_fifa_match GET    /my_fifa/matches/:id/edit(.:format)              my_fifa/matches#edit
#                     my_fifa_match GET    /my_fifa/matches/:id(.:format)                   my_fifa/matches#show
#                                   PATCH  /my_fifa/matches/:id(.:format)                   my_fifa/matches#update
#                                   PUT    /my_fifa/matches/:id(.:format)                   my_fifa/matches#update
#                                   DELETE /my_fifa/matches/:id(.:format)                   my_fifa/matches#destroy
# competitions_json_my_fifa_seasons GET    /my_fifa/seasons/competitions_json(.:format)     my_fifa/seasons#competitions_json
#       competitions_my_fifa_season GET    /my_fifa/seasons/:id/competitions(.:format)      my_fifa/seasons#competitions
#                   my_fifa_seasons GET    /my_fifa/seasons(.:format)                       my_fifa/seasons#index
#                                   POST   /my_fifa/seasons(.:format)                       my_fifa/seasons#create
#               edit_my_fifa_season GET    /my_fifa/seasons/:id/edit(.:format)              my_fifa/seasons#edit
#                    my_fifa_season GET    /my_fifa/seasons/:id(.:format)                   my_fifa/seasons#show
#                                   PATCH  /my_fifa/seasons/:id(.:format)                   my_fifa/seasons#update
#                                   PUT    /my_fifa/seasons/:id(.:format)                   my_fifa/seasons#update
#                                   DELETE /my_fifa/seasons/:id(.:format)                   my_fifa/seasons#destroy
#              my_fifa_competitions GET    /my_fifa/competitions(.:format)                  my_fifa/competitions#index
#                                   POST   /my_fifa/competitions(.:format)                  my_fifa/competitions#create
#           new_my_fifa_competition GET    /my_fifa/competitions/new(.:format)              my_fifa/competitions#new
#          edit_my_fifa_competition GET    /my_fifa/competitions/:id/edit(.:format)         my_fifa/competitions#edit
#               my_fifa_competition GET    /my_fifa/competitions/:id(.:format)              my_fifa/competitions#show
#                                   PATCH  /my_fifa/competitions/:id(.:format)              my_fifa/competitions#update
#                                   PUT    /my_fifa/competitions/:id(.:format)              my_fifa/competitions#update
#                                   DELETE /my_fifa/competitions/:id(.:format)              my_fifa/competitions#destroy
#             my_fifa_player_season PATCH  /my_fifa/player_seasons/:id(.:format)            my_fifa/player_seasons#update
#                                   PUT    /my_fifa/player_seasons/:id(.:format)            my_fifa/player_seasons#update
#                info_my_fifa_squad GET    /my_fifa/squads/:id/info(.:format)               my_fifa/squads#info
#                    my_fifa_squads GET    /my_fifa/squads(.:format)                        my_fifa/squads#index
#                                   POST   /my_fifa/squads(.:format)                        my_fifa/squads#create
#                 new_my_fifa_squad GET    /my_fifa/squads/new(.:format)                    my_fifa/squads#new
#                     my_fifa_squad GET    /my_fifa/squads/:id(.:format)                    my_fifa/squads#show
#                                   PATCH  /my_fifa/squads/:id(.:format)                    my_fifa/squads#update
#                                   PUT    /my_fifa/squads/:id(.:format)                    my_fifa/squads#update
#                                   DELETE /my_fifa/squads/:id(.:format)                    my_fifa/squads#destroy
#      set_active_my_fifa_formation POST   /my_fifa/formations/:id/set_active(.:format)     my_fifa/formations#set_active
#            info_my_fifa_formation GET    /my_fifa/formations/:id/info(.:format)           my_fifa/formations#info
#                my_fifa_formations GET    /my_fifa/formations(.:format)                    my_fifa/formations#index
#                                   POST   /my_fifa/formations(.:format)                    my_fifa/formations#create
#             new_my_fifa_formation GET    /my_fifa/formations/new(.:format)                my_fifa/formations#new
#            edit_my_fifa_formation GET    /my_fifa/formations/:id/edit(.:format)           my_fifa/formations#edit
#                 my_fifa_formation GET    /my_fifa/formations/:id(.:format)                my_fifa/formations#show
#                                   PATCH  /my_fifa/formations/:id(.:format)                my_fifa/formations#update
#                                   PUT    /my_fifa/formations/:id(.:format)                my_fifa/formations#update
#                                   DELETE /my_fifa/formations/:id(.:format)                my_fifa/formations#destroy
# 

Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  mount ActionCable.server => '/cable'

  root 'home#index'

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

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
        get 'info'
      }
    end

    resources :analytics, only: [:index] do
      collection {
        get 'players'

        get 'charts'
        get 'stats'
      }
    end
  end
end
