module MyFifa
  class Fixture < Base
    belongs_to :competition

    serialize :home_score, Array
    serialize :away_score, Array

    %w(home away).each do |type|
      define_method "#{type}_score=" do |val|
        if val.is_a? Array
          write_attribute "#{type}_score", val
        else
          write_attribute "#{type}_score", val.split(",").map(&:strip)
        end
      end
    end

    ######################
    #  CALLBACK METHODS  #
    ######################
      after_save :save_team_names
      
      def save_team_names
        team = self.competition.team
        save_team_name(team, self.home_team)
        save_team_name(team, self.away_team)
      end
      
    private
    
      def save_team_name(my_team, team_name)
        unless team_name.blank? || my_team.teams_played.include?(team_name) || my_team.team_name == team_name
          my_team.teams_played << team_name
          my_team.save
        end
      end
  end
end
