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

require 'rails_helper'

RSpec.describe MyFifa::Season, type: :model do
end
