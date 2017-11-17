# == Schema Information
#
# Table name: my_fifa_matches
#
#  id           :integer          not null, primary key
#  team_id      :integer
#  opponent     :string           not null
#  competition  :string           not null
#  score_gf     :integer          not null
#  score_ga     :integer          not null
#  penalties_gf :integer
#  penalties_ga :integer
#  date_played  :date
#  motm_id      :integer
#  home         :boolean          default(TRUE)
#  squad_id     :integer
#  season_id    :integer
#

require 'rails_helper'

RSpec.describe MyFifa::Match, type: :model do
end
