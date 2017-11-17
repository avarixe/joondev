# == Schema Information
#
# Table name: my_fifa_competitions
#
#  id                  :integer          not null, primary key
#  type                :string
#  team_id             :integer
#  season_id           :integer
#  title               :string
#  champion            :string
#  num_teams           :integer          default(16)
#  matches_per_fixture :integer          default(1)
#  num_groups          :integer
#  num_advances        :integer
#

require 'rails_helper'

RSpec.describe MyFifa::Competition, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
