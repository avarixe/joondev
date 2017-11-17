# == Schema Information
#
# Table name: my_fifa_contract_terms
#
#  id             :integer          not null, primary key
#  contract_id    :integer
#  end_date       :date
#  wage           :integer
#  signing_bonus  :integer
#  stat_bonus     :integer
#  num_stats      :integer
#  stat_type      :string
#  release_clause :integer
#  start_date     :date
#

module MyFifa
  # Wage + Bonus Information for a Contract
  class ContractTerm < Base
    default_scope { order(id: :asc) }

    belongs_to :contract, inverse_of: :terms

    ########################
    #  VALIDATION METHODS  #
    ########################
    validates :wage, presence: { message: 'Wage cannot be blank.' }
    validate :stat_bonus_has_requirements?,
             if: proc { |t| t.stat_bonus.present? }

    def stat_bonus_has_requirements?
      return unless num_stats.blank? || stat_type.blank?
      errors.add(:base, 'Bonus does not have a Requirement.')
    end

    ######################
    #  CALLBACK METHODS  #
    ######################
    after_save :update_contract_end_date

    def update_contract_end_date
      contract.update_column(:end_date, end_date)
    end

    ######################
    #  ACCESSOR METHODS  #
    ######################
    def bonuses
      bonuses = number_to_fee(signing_bonus, '')
      if stat_bonus.present?
        stat_bonus_str =
          number_to_fee(stat_bonus, '', '%n%u') +
          " if #{num_stats} #{stat_type}"
        bonuses + " (+#{stat_bonus_str})"
      else
        bonuses
      end
    end
  end
end
