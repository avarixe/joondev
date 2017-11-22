require_dependency 'my_fifa/application_controller'

module MyFifa
  # :nodoc:
  class PlayersController < ApplicationController
    before_action :set_current_team
    before_action :set_player, except: %i[index search show new create]
    before_action :set_player_complete, only: [:show]
    before_action :set_grouped_players, only: %i[show new edit]
    include PlayersHelper
    include MatchesHelper

    # GET /players
    def index
      respond_to do |format|
        format.html { @title = 'Players' }
        format.json do
          @records = @team.player_records
          filter_records
          render json: {
            data: @players
          }.to_json(methods: %i[ovr national_flag])
        end
      end
    end

    def search
      if (results = find_player)
        redirect_to results
      else
        redirect_to action: :index
      end
    end

    def show
      @title = @player.name
      @stats = [
        { type: :num_games,   label: 'Games Played',     color: 'blue'   },
        { type: :num_motm,    label: 'Man of the Match', color: 'yellow' },
        { type: :num_goals,   label: 'Goals Scored',     color: 'teal'   },
        { type: :num_assists, label: 'Goal Assists',     color: 'brown'  },
        { type: :num_cs,      label: 'Clean Sheets',     color: 'pink'   }
      ]
    end

    # GET /players/new
    def new
      @player = Player.new.init(@team.id)
      @title = 'New Player'
    end

    # POST /players
    def create
      @player = Player.new(player_params)

      if @team.players << @player
        redirect_to @player
      else
        respond_to do |format|
          format.js { render 'shared/errors', locals: { object: @player } }
        end
      end
    end

    def edit
      @title = "Edit Player: #{@player.name}"
    end

    # POST /players/update_json
    def update
      if @player.update(player_params)
        redirect_to @player
      else
        respond_to do |format|
          format.js { render 'shared/errors', locals: { object: @player } }
        end
      end
    end

    def set_status
      if params[:date].present?
        @date = Date.strptime(params[:date])
        @player.set_current_date(@team, @date)
      elsif params[:type] != 'recover'
        status 500
      end
      toggle_player_status
      respond_to { |format| format.js }
    end

    def sign_new_contract
      @term = @player.current_contract.terms.build(params[:term].permit!)

      respond_to do |format|
        format.js do
          if @term.save
            render 'my_fifa/players/manage/sign_new_contract'
          else
            render 'shared/errors', locals: { object: @term }
          end
        end
      end
    end

    def exit
      @contract = @player.contracts.last

      if @contract.update(params[:contract].permit!)
        @player.update_column(:active, false)
        redirect_to my_fifa_players_path
      else
        respond_to do |format|
          format.js { render 'shared/errors', locals: { object: @contract } }
        end
      end
    end

    def rejoin
      @contract = @player.contracts.new(params[:contracts].permit!)

      if @contract.save
        @player.update_column(:active, true)
        redirect_to @player
      else
        respond_to do |format|
          format.js { render 'shared/errors', locals: { object: @contract } }
        end
      end
    end

    private

    # Only allow a trusted parameter "white list" through.
    def player_params
      params[:player].permit!
    end

    def set_player
      @player = Player.find(params[:id])
    end

    def set_grouped_players
      @grouped_players = Player.grouped_by_pos(@team.players.active)
    end

    def set_player_complete
      @player = Player
                .includes(
                  records: %i[match sub_record],
                  contracts: %i[terms transfer_cost exit_cost],
                  injuries: [],
                  loans: [],
                  player_seasons: [:season]
                ).find(params[:id])
    end

    def find_player
      return if params[:player].blank?
      Player.unscoped do
        @team.players
             .where(team_id: @team.id)
             .find_name(params[:player])
      end
    end
  end
end
