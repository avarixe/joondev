# == Schema Information
#
# Table name: my_fifa_squads
#
#  id           :integer          not null, primary key
#  team_id      :integer
#  squad_name   :string           not null
#  player_id_1  :integer
#  player_id_2  :integer
#  player_id_3  :integer
#  player_id_4  :integer
#  player_id_5  :integer
#  player_id_6  :integer
#  player_id_7  :integer
#  player_id_8  :integer
#  player_id_9  :integer
#  player_id_10 :integer
#  player_id_11 :integer
#  formation_id :integer
#

require 'rails_helper'

RSpec.describe MyFifa::Squad, type: :model do
end
