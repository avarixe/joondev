# == Schema Information
#
# Table name: my_fifa_match_logs
#
#  id         :integer          not null, primary key
#  match_id   :integer
#  event      :string
#  minute     :integer
#  player1_id :integer
#  player2_id :integer
#  notes      :text
#

require 'rails_helper'

RSpec.describe MyFifa::MatchLog, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
