# == Schema Information
#
# Table name: my_fifa_player_events
#
#  id          :integer          not null, primary key
#  type        :string
#  player_id   :integer
#  start_date  :date
#  end_date    :date
#  loan        :boolean          default(FALSE)
#  origin      :string
#  destination :string
#  notes       :text
#

require 'rails_helper'

RSpec.describe MyFifa::Injury, type: :model do
end
