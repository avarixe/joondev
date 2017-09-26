module MyFifa
  class Contract < Event
    self.table_name = 'my_fifa_contracts'
    
    belongs_to :player
    
    has_many :terms, class_name: 'ContractTerm'
    has_one :transfer_cost, -> { where dir: 'in' }, class_name: 'Cost'
    accepts_nested_attributes_for :transfer_cost
    has_one :exit_cost, -> { where dir: 'out' }, class_name: 'Cost'
    accepts_nested_attributes_for :exit_cost

    ############################
    #  INITIALIZATION METHODS  #
    ############################
      def init
        build_transfer_cost
        return self
      end

    ########################
    #  VALIDATION METHODS  #
    ########################
      validates :start_date, presence: { message: "Contract Start cannot be blank." }
      validate :valid_contract?

      def valid_contract?
        if loan.present?
          if origin.blank?
            errors.add(:base, "A Loaned player must have an Origin.")
          elsif transfer_cost.player_id.present?
            errors.add(:base, "A player cannot be traded for a Loaned player.")            
          end
        elsif origin.blank? && [transfer_cost.fee, transfer_cost.player_id].any?(&:present?)
          errors.add(:base, "A player cannot have a Transfer Cost without an Origin.")
        end
      end
  end
end