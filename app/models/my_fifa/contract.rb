module MyFifa
  class Contract < PlayerEvent
    has_many :terms, class_name: 'ContractTerm', inverse_of: :contract, dependent: :delete_all
    accepts_nested_attributes_for :terms
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
        self.terms.build
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
        elsif ([exit_cost.fee, exit_cost.player_id].any?(&:present?) rescue false)
          if destination.blank?
            errors.add(:base, "A player cannot have a Transfer Cost without a Destination.")            
          end
        elsif [transfer_cost.fee, transfer_cost.player_id].any?(&:present?)
          if origin.blank?
            errors.add(:base, "A player cannot have a Transfer Cost without an Origin.")
          end
        end
      end
      
    ######################
    #  CALLBACK METHODS  #
    ######################
      after_create :set_term_start_date
      
      def set_term_start_date
        self.terms.last.update_column(:start_date, self.start_date)
      end


    #####################
    #  MUTATOR METHODS  #
    #####################
      def build_new_term
        self.terms.any? ?
          self.terms.build(terms.last.attributes.except('id')) :
          self.terms.build
      end

    ######################
    #  ACCESSOR METHODS  #
    ######################
  end
end