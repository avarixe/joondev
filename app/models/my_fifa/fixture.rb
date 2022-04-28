# == Schema Information
#
# Table name: my_fifa_fixtures
#
#  id              :integer          not null, primary key
#  competition_id  :integer
#  home_fixture_id :integer
#  away_fixture_id :integer
#  home_team       :string
#  away_team       :string
#  home_score      :string
#  away_score      :string
#

module MyFifa
  # Match Fixture in a Cup or Tournament
  class Fixture < Base
    default_scope { order(id: :asc) }

    belongs_to :competition

    serialize :home_score, Array
    serialize :away_score, Array

    %w[home away].each do |type|
      define_method "#{type}_score=" do |val|
        if val.is_a? Array
          write_attribute "#{type}_score", val
        else
          write_attribute "#{type}_score", val.split(',').map(&:strip)
        end
      end
    end

    ######################
    #  CALLBACK METHODS  #
    ######################
    after_save :save_team_names

    def save_team_names
      team = competition.team
      save_team_name(team, home_team)
      save_team_name(team, away_team)
    end

    ######################
    #  ACCESSOR METHODS  #
    ######################
    def completed?
      [
        home_team,
        away_team,
        home_score,
        away_score
      ].all?(&:present?)
    end

    private

    def save_team_name(my_team, team_name)
      return if team_name.blank? ||
                my_team.teams_played.include?(team_name) ||
                my_team.team_name == team_name
      my_team.teams_played << team_name
      my_team.save
    end
  end
end
