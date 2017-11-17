# == Schema Information
#
# Table name: my_fifa_costs
#
#  id            :integer          not null, primary key
#  player_id     :integer
#  fee           :integer
#  event_id      :integer
#  notes         :text
#  dir           :string           default("in")
#  add_on_clause :integer          default(0)
#

require 'rails_helper'

RSpec.describe MyFifa::Cost, type: :model do
end
