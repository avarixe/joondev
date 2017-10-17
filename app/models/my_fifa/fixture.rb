module MyFifa
  class Fixture < Base
    belongs_to :competition

    FINAL_ROUNDS = {
      8 => 'Quarter Finals',
      4 => 'Semi Finals',
      2 => 'Final',
    }
  end
end
