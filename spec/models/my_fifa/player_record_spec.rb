# == Schema Information
#
# Table name: my_fifa_player_records
#
#  id           :integer          not null, primary key
#  team_id      :integer
#  match_id     :integer
#  player_id    :integer
#  rating       :integer
#  goals        :integer
#  assists      :integer
#  pos          :string(10)
#  cs           :boolean
#  record_id    :integer
#  yellow_cards :integer          default(0)
#  red_cards    :integer          default(0)
#  injury       :string
#

require 'rails_helper'

RSpec.describe MyFifa::PlayerRecord, type: :model do
end
