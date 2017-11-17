# == Schema Information
#
# Table name: my_fifa_teams
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  team_name    :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  current_date :date
#  teams_played :text
#

module MyFifa
  # CareerMode Team
  class Team < Base
    default_scope { order(id: :asc) }

    belongs_to :user
    has_many :seasons, dependent: :destroy
    has_many :competitions, dependent: :destroy
    has_many :players, dependent: :destroy
    has_many :squads,  dependent: :delete_all
    has_many :matches, dependent: :delete_all
    has_many :player_records, dependent: :delete_all

    serialize :teams_played, Array

    ########################
    #  ASSIGNMENT METHODS  #
    ########################
    def teams_played=(val)
      write_attribute :teams_played,
                      (val.is_a?(Array) ? val : val.split("\n").map(&:strip))
    end

    ########################
    #  VALIDATION METHODS  #
    ########################
    validates :team_name, presence: { message: 'Team Name is blank.' }
    validates :current_date, presence: { message: 'Start Date is blank.' }

    ######################
    #  CALLBACK METHODS  #
    ######################
    after_create :create_first_season

    def create_first_season
      new_player_seasons = []

      new_player_seasons << seasons.build(
        start_date: current_date,
        end_date:   current_date + 1.year
      )

      PlayerSeason.transaction do
        new_player_seasons.map(&:save)
      end
    end

    ######################
    #  ACCESSOR METHODS  #
    ######################
    def playable?
      players.count >= 11
    end

    def current_season
      seasons.last
    end

    def recorded_competitions
      competitions.map(&:title).uniq
    end
  end
end
