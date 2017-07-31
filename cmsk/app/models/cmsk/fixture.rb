module Cmsk
  class Fixture < Base
    belongs_to :stage
    has_one :game
  end
end
