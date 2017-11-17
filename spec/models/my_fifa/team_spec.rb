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

require 'rails_helper'

RSpec.describe MyFifa::Team, type: :model do

  context "A New Team" do
    it "is only valid if Team Name, Current Date, and Competitions present" do 
      team = MyFifa::Team.new
      expect(team.valid?).to be false
      team.team_name = "Team"
      expect(team.valid?).to be false
      team.current_date = Time.now.to_date
      expect(team.valid?).to be false
      team.competitions = ['A']
      expect(team.valid?).to be true
    end
    
    it "automatically creates a Season upon creation" do
      team = MyFifa::Team.new(
        team_name: "Team",
        current_date: Time.now.to_date,
        competitions: ['A']
      )
      expect(team.save).to be true
      
      expect(team.current_season).not_to be nil
      expect(team.seasons.length).to be 1
      expect(team.seasons.first).to be team.current_season
    end
  end

end
