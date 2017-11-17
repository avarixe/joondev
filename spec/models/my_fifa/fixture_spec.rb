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

require 'rails_helper'

RSpec.describe MyFifa::Fixture, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
