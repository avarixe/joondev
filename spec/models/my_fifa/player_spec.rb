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
