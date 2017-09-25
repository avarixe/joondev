require_dependency "my_fifa/application_controller"

module MyFifa
  class PlayersController < ApplicationController
    before_action :set_current_team
    before_action :set_player, only: [:edit, :update, :set_status, :exit, :rejoin, :get_ovr]

    # GET /players
    def index
      @players = @team.sorted_players.includes(:matches)
      @inactive_players = @team.players.inactive.includes(:matches).sorted
      @all_players = @players+@inactive_players
      @title = "Players"
    end

    def show
      @player = Player.includes(records: [:match]).find(params[:id])
      @title = @player.name

      @stats = [
        { type: :num_games,   label: 'Games Played',     color: 'blue'   },
        { type: :num_motm,    label: 'Man of the Match', color: 'yellow' },
        { type: :num_goals,   label: 'Goals Scored',     color: 'teal'   },
        { type: :num_assists, label: 'Goal Assists',     color: 'brown'  },
        { type: :num_cs,      label: 'Clean Sheets',     color: 'pink'   },
      ]
    end

    # GET /players/new
    def new
      @player = Player.new.init(@team.id)
      @title = "New Player"
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
      date = params[:date] || @team.current_date

      case params[:type]
      when 'injury', 'recover'
        @player.toggle_injury(date)
      when 'loan', 'return'
        notes = params[:notes]
        @player.toggle_loan(date, notes)
      end

      respond_to do |format|
        format.js
      end
    end

    def exit
      @contract = @player.contracts.last

      if @contract.update(params[:contract].permit!)
        @player.update_column(:active, false)
        redirect_to action: :index, notice: "#{@player.name} has left #{@team.team_name}"
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
        redirect_to @player, notice: "#{@player.name} has rejoined #{@team.team_name}"
      else
        respond_to do |format|
          format.js { render 'shared/errors', locals: { object: @contract } }
        end
      end
    end

    def get_ovr
      render json: @player.current_ovr.to_json
    end

    private
      # Only allow a trusted parameter "white list" through.
      def player_params
        params[:player].permit!
      end

      def set_player
        @player = Player.find(params[:id])
      end
  end
end
