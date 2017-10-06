module MyFifa
  class ContractTerm < Base
    default_scope { order(id: :asc)}

    belongs_to :contract, inverse_of: :terms

    ########################
    #  VALIDATION METHODS  #
    ########################
      validates :wage, presence: { message: "Wage cannot be blank." }
      validate :stat_bonus_has_requirements?

      def stat_bonus_has_requirements?
        if self.stat_bonus.present? && [self.num_stats, self.stat_type].any?(&:blank?)
          errors.add(:base, "Bonus does not have a Requirement.")
        end
      end

    ######################
    #  CALLBACK METHODS  #
    ######################
      after_save :update_contract_end_date

      def update_contract_end_date
        contract.update_column(:end_date, self.end_date)
      end

    ######################
    #  ACCESSOR METHODS  #
    ######################
      def bonuses
        bonuses = number_to_fee(self.signing_bonus, '')
        if self.stat_bonus.present?
          bonuses += " (+#{number_to_fee(term.stat_bonus, '', "%n%u")} if #{term.num_stats} #{term.stat_type})"
        end
        return bonuses
      end

  end
end
