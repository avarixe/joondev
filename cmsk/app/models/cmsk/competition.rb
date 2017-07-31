module Cmsk
  class Competition < Base
    belongs_to :team
    has_many :stages, dependent: :destroy
    accepts_nested_attributes_for :stages, allow_destroy: true, reject_if: :invalid_stage?

    def invalid_stage?(stage)
      [:category, :num_plays, :teams].any?{ |att| stage[att].blank? }
    end
  end
end
