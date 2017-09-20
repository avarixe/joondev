require_dependency "my_fifa/application_controller"

module MyFifa
  class PlayersController < ApplicationController
    before_action :set_current_team
    before_action :set_player, only: [:show, :edit, :update, :exit, :sign, :get_ovr]

    # GET /players
    def index
      @players = @team.sorted_players
      @inactive_players = @team.players.inactive
      @all_players = @players+@inactive_players
      @title = "Players"
    end

    def show
      @title = @player.name
    end

    # GET /players/new
    def new
      @player = Player.new
      @title = "New Player"
    end

    # POST /players
    def create
      @player = Player.new(player_params)

      if @team.players.push @player
        redirect_to action: 'index'
      else
        @title = "New Player"
        render :new
      end
    end

    def edit
      @title = "Edit Player: #{@player.name}"
    end

    # POST /players/update_json
    def update
      @player = Player.find(params[:id])
  
      status, message = 
        if @team.players.include? @player
          @player.update_attributes(player_params) ? 
            ['success', 'Player has been updated.'] : 
            ['error', 'Player could not be updated.']
        else
          ['error', 'You cannot access this Player.']
        end

      render_json_response(status, message)
    end

    def exit
      @player.update_attributes(active: false)
      redirect_to :back
    end

    def sign
      @player.update_attributes(active: true)
      redirect_to @player
    end

    def import_csv
      status, message = ['', '']
      players = []

      # Validate uploaded CSV is in proper format
      if (rows = params[:file]).present?
        rows.tr("\r", '').split("\n").each do |row|
          name, pos, sec_pos = row.split(';')
          if name.blank? || pos.blank?
            status, message = ['error', 'Invalid CSV File.']
            break
          elsif Player.positions.include?(pos) == false
            status, message = ['error', "#{name} has an Invalid Position."]
            break
          else
            players.push(
              name: name,
              pos: pos,
              sec_pos: sec_pos
            )
          end
        end
      else
        status, message = ['error', 'Blank CSV File.']
      end
      
      # Create Players
      unless players.blank? || status == 'error'
        players.each do |player|
          @team.players.push Player.new(
            name:    player[:name],
            pos:     player[:pos],
            sec_pos: player[:sec_pos]
          )
        end
        status, message = ['success', 'Players have been added.']
      end
      
      render_json_response(status, message)
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
