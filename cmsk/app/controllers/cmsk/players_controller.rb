require_dependency "cmsk/application_controller"

module Cmsk
  class PlayersController < ApplicationController
    before_action :set_current_team

    # GET /players
    def index
      @players = @team.sorted_players
      @inactive_players = @team.players.inactive
      @title = "#{@team.team_name} - Players"
      
      puts @players.map(&:name).inspect
    end

    # GET /players/new
    def new
      @player = Player.new
      @title = "#{@team.team_name} - New Player"
    end

    # POST /players
    def create
      @player = Player.new(player_params)

      if @team.players.push @player
        redirect_to action: 'index'
      else
        render :new
      end
    end

    # POST /players/update_json
    def update_json
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

    private
      # Only allow a trusted parameter "white list" through.
      def player_params
        params[:player].permit!
      end
  end
end
