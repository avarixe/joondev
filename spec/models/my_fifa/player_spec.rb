# == Schema Information
#
# Table name: my_fifa_players
#
#  id          :integer          not null, primary key
#  team_id     :integer
#  name        :string           not null
#  pos         :string           not null
#  sec_pos     :string
#  active      :boolean          default(TRUE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  start_ovr   :integer          default(0)
#  nationality :string
#  youth       :boolean          default(FALSE)
#  notes       :text
#  status      :string           default("")
#  start_value :integer          default(0)
#  start_age   :integer          default(0)
#

require 'rails_helper'

RSpec.describe MyFifa::Player, type: :model do
  
  context "A new Player" do
    player = MyFifa::Player.new

    it "will not save with no parameters" do
      player = MyFifa::Player.new
      expect(MyFifa::Player.new.save).to eql false
    end
  end
end
