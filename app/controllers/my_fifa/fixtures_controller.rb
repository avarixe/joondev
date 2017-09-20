require_dependency "my_fifa/application_controller"

module MyFifa
  class FixturesController < ApplicationController
    before_action :set_fixture, only: [:show, :edit, :update, :destroy]
    before_action :set_current_team

    # GET /players
    def index
      respond_to do |format|
        format.html {
          @title = "Fixture Archives"
        }
        format.json {
          @fixtures = @team.fixtures
          render json: {
            data: @fixtures.with_motm.reverse.map{ |fixture|
              {
                id:          fixture.id,
                result:      fixture.result,
                opponent:    fixture.opponent,
                competition: fixture.competition,
                score:       fixture.score,
                motm:        fixture.motm_name,
                date_played: time_to_string(fixture.date_played, '%b %e, %Y')
              }
            }
          }.to_json
        }
      end
    end

    # GET /players/1
    def show         
      respond_to do |format|
        @records = @fixture.player_records.with_player

        format.html {
          @title = "Fixture Record"
        }
        format.xlsx {
          # Prepare Copy Table
          @data = { 
            ratings: [],
            goals: [],
            assists: []
          }
          player_ids = @records.map(&:player_id)
          @team.sorted_players.each do |player|
            played = player_ids.include?(player.id)

            if played
              record = @records.find_by(player_id: player.id)

              @data[:ratings] << record.rating
              @data[:goals]   << record.goals
              @data[:assists] << record.assists
            else
              @data[:ratings] << nil
              @data[:goals]   << nil
              @data[:assists] << nil
            end
          end
        }
      end
    end

    # GET /players/new
    def new
      @title = "New Fixture"
      last_played = @team.fixtures.last.date_played unless @team.fixtures.empty?
      @fixture = Fixture.new(date_played: last_played)

      @fixture.build_records
      @grouped_players = @team.grouped_players
    end

    # GET /players/1/edit
    def edit
      @title = "Edit Fixture"
      @grouped_players = @team.grouped_players
    end

    # POST /players
    def create
      @fixture = Fixture.new(fixture_params)

      if @team.fixtures << @fixture
        redirect_to @fixture, notice: 'Fixture was successfully created.'
      else
        @title = "New Fixture"
        @grouped_players = @team.grouped_players
        render :new
      end
    end

    # PATCH/PUT /players/1
    def update
      if @fixture.update_attributes(fixture_params)
        redirect_to @fixture, notice: 'Fixture was successfully updated.'
      else
        @title = "Edit Fixture"
        @grouped_players = @team.grouped_players
        render :edit
      end
    end

    # DELETE /players/1
    def destroy
      @fixture.destroy
      redirect_to fixtures_url, notice: 'Fixture was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_fixture
        @fixture = Fixture.with_motm.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def fixture_params
        params[:fixture].permit!
      end
  end
end
