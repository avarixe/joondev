# == Schema Information
#
# Table name: my_fifa_player_events
#
#  id          :integer          not null, primary key
#  type        :string
#  player_id   :integer
#  start_date  :date
#  end_date    :date
#  loan        :boolean          default(FALSE)
#  origin      :string
#  destination :string
#  notes       :text
#

module MyFifa
  # Player Event: Signing new Contract with the Team
  class Contract < PlayerEvent
    has_many :terms,
             class_name: 'ContractTerm',
             inverse_of: :contract,
             dependent: :delete_all
    has_one :transfer_cost,
            -> { where dir: 'in' },
            foreign_key: :event_id,
            class_name: 'Cost'
    has_one :exit_cost,
            -> { where dir: 'out' },
            foreign_key: :event_id,
            class_name: 'Cost'
    accepts_nested_attributes_for :terms
    accepts_nested_attributes_for :transfer_cost
    accepts_nested_attributes_for :exit_cost

    ############################
    #  INITIALIZATION METHODS  #
    ############################
    def init
      build_transfer_cost
      build_exit_cost
      terms.build
      self
    end

    ########################
    #  VALIDATION METHODS  #
    ########################
    validates :start_date,
              presence: { message: 'Contract Start cannot be blank.' }
    validate :valid_loan?, if: proc { |c| c.loan.present? }
    validate :valid_exit?, if: proc { |c| c.exit_cost.present? }
    validate :valid_transfer?

    def valid_loan?
      if origin.blank?
        errors.add(:base, 'A Loaned player must have an Origin.')
      elsif transfer_cost.player_id.present?
        errors.add(:base, 'A player cannot be traded for a Loaned player.')
      end
    end

    def valid_exit?
      return if exit_cost.fee.nil? && exit_cost.player_id.nil?
      return unless destination.blank?
      errors.add(
        :base,
        'A player cannot have a Transfer Cost without a Destination.'
      )
    end

    def valid_transfer?
      return if transfer_cost.fee.nil? && transfer_cost.player_id.nil?
      return unless origin.blank?
      errors.add(
        :base,
        'A player cannot have a Transfer Cost without an Origin.'
      )
    end

    ######################
    #  CALLBACK METHODS  #
    ######################
    after_create :set_term_start_date

    def set_term_start_date
      terms.last.update_column(:start_date, start_date)
    end

    #####################
    #  MUTATOR METHODS  #
    #####################
    def build_new_term
      if terms.any?
        terms.build(terms.last.attributes.except('id'))
      else
        terms.build
      end
    end
  end
end
