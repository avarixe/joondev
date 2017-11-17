# == Schema Information
#
# Table name: my_fifa_player_seasons
#
#  id        :integer          not null, primary key
#  season_id :integer
#  player_id :integer
#  kit_no    :integer
#  value     :integer
#  ovr       :integer
#  age       :integer          default(0)
#

require 'rails_helper'

RSpec.describe MyFifa::PlayerSeason, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
