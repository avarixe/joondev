module MyFifa
  class Contract < PlayerEvent
    has_one :transfer_cost, -> { where dir: 'in' }, foreign_key: :event_id, class_name: 'Cost'
    accepts_nested_attributes_for :transfer_cost
    has_one :exit_cost, -> { where dir: 'out' }, foreign_key: :event_id, class_name: 'Cost'
    accepts_nested_attributes_for :exit_cost

    ############################
    #  INITIALIZATION METHODS  #
    ############################
      def init
        build_transfer_cost
        build_exit_cost
        return self
      end

    ########################
    #  VALIDATION METHODS  #
    ########################
      validates :date_effective, presence: { message: "Contract Start cannot be blank." }
      validate :valid_contract?

      def valid_contract?
        if loan.present?
          if party.blank?
            errors.add(:base, "A Loaned player must have an Origin.")
          elsif transfer_cost.player_id.present?
            errors.add(:base, "A player cannot be traded for a Loaned player.")            
          end
        elsif party.blank? && [transfer_cost.price, transfer_cost.player_id].any?(&:present?)
          errors.add(:base, "A player cannot have a Transfer Cost without an Origin.")
        end
      end
  end
end