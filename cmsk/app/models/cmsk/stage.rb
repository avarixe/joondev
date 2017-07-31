module Cmsk
  class Stage < Base
    belongs_to :competition
    has_many :fixtures, dependent: :destroy

    CATEGORIES = [
      'Knockout',
      'League'
    ]

    serialize :opponents

    def opponents=(val)
      write_attribute :opponents, (val.is_a?(Array) ? val : val.split("\n").map(&:strip))
    end
  end
end
