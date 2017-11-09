require_dependency "my_fifa/application_controller"

module MyFifa
  class PlayersController < ApplicationController
    before_action :set_current_team
    before_action :set_player, only: [:edit, :update, :set_status, :sign_new_contract, :exit, :rejoin]
    include MatchAnalytics

    # GET /players
    def index
      respond_to do |format|
        format.html {
          @players = @team.sorted_players.includes(:player_seasons)
          @inactive_players = @team.players.inactive.includes(:player_seasons).sorted
          @all_players = @players+@inactive_players
          @title = "Players"
        }
        format.json {
          @records = @team.player_records
          filter_records

          @players = Player.includes(:records, :player_seasons).with_stats(@matches.map(&:id))
            .where(id: @records.map(&:player_id).uniq)

          @players = @players.where(active: true) if str_to_bool(params[:active_only])

          render json: {
            data: @players
          }.to_json(methods: [:ovr, :national_flag])
        }
      end
    end

    def search
      if params[:player].blank?
        redirect_to action: :index
      else
        results = Player.unscoped{
          @team.players.where(team_id: @team.id)
            .where('LOWER(name) LIKE ?', "%#{params[:player].downcase}%")
            .order('active DESC')
        }
        if results.any?
          redirect_to results.first
        else
          redirect_to action: :index
        end
      end
    end

    def show
      @player = Player.includes(records: [:match, :sub_record], contracts: [:terms, :transfer_cost, :exit_cost], injuries: [], loans: [], player_seasons: [:season]).find(params[:id])
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
      if params[:date].blank? && params[:type] != "recover"
        status 500
      elsif params[:date].present?
        date = Date.strptime(params[:date]) || @team.current_date
        @team.update_column(:current_date, date) if @team.current_date < date
      end

      case params[:type]
      when 'injury'
        @player.toggle_injury(date, params[:notes])
        @icon = 'pink first aid'
        @message = "#{@player.name} is injured."
      when 'recover'
        @player.toggle_injury(date, params[:notes])
        if @player.injured?
          @icon = 'pink first aid'
          @message = "#{@player.name} Injury Status has been updated."
        else
          @icon = 'green first aid'
          @message = "#{@player.name} is no longer injured."
        end
      when 'loan'
        @player.toggle_loan(date, params[:notes])
        @icon = 'orange plane'
        @message = "#{@player.name} has been loaned out#{ " to #{params[:notes]}"}."
      when 'return'
        @player.toggle_loan(date, params[:notes])
        @icon = 'green plane'
        @message = "#{@player.name} has returned to the club."
      end

      respond_to do |format|
        format.js
      end
    end

    def sign_new_contract
      @contract = @player.current_contract
      @term = @contract.terms.build(params[:term].permit!)
      @term.start_date = @team.current_date

      respond_to do |format|
        format.js { 
          if @term.save
            render 'my_fifa/players/manage/sign_new_contract'
          else
            render 'shared/errors', locals: { object: @term }
          end
        }
      end
    end

    def exit
      @contract = @player.contracts.last

      if @contract.update(params[:contract].permit!)
        @player.update_column(:active, false)
        redirect_to my_fifa_players_path, notice: "#{@player.name} has left #{@team.team_name}"
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
