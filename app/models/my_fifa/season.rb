# == Schema Information
#
# Table name: my_fifa_seasons
#
#  id               :integer          not null, primary key
#  team_id          :integer
#  captain_id       :integer
#  start_date       :date
#  end_date         :date
#  start_club_worth :integer
#  end_club_worth   :integer
#  transfer_budget  :integer
#  wage_budget      :integer
#

module MyFifa
  # Annual Season in CareerMode
  class Season < Base
    default_scope { order(id: :asc) }

    belongs_to :team
    belongs_to :captain, class_name: 'Player'

    has_many :competitions
    has_many :player_seasons, dependent: :delete_all
    has_many :players, through: :player_seasons
    has_many :matches

    ########################
    #  VALIDATION METHODS  #
    ########################
    validates :start_date, presence: { message: 'Start Date cannot be blank.' }
    validates :end_date,   presence: { message: 'End Date cannot be blank.' }

    #####################
    #  MUTATOR METHODS  #
    #####################

    # rubocop:disable all
    def build_next_season
      new_season = dup
      new_season.start_date       = end_date
      new_season.end_date         = end_date + 1.year
      new_season.start_club_worth = end_club_worth
      new_season.end_club_worth   = nil
      new_season.save
      player_seasons.includes(:player).each do |player_season|
        next unless player_season.player.active?
        new_player_season = player_season.dup
        new_player_season.season_id = new_season.id
        new_player_season.age += 1
        new_player_season.save
      end
      new_season
    end
    # rubocop:enable all

    ######################
    #  ACCESSOR METHODS  #
    ######################
    def current?
      (start_date..end_date).cover? team.current_date
    end

    def yearspan
      "#{start_date.strftime('%Y')} - #{end_date.strftime('%Y')}"
    end

    def title
      "#{yearspan} Season"
    end

    def competition_options
      competitions.map(&:title)
    end
  end
end
