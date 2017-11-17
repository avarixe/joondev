# == Schema Information
#
# Table name: my_fifa_costs
#
#  id            :integer          not null, primary key
#  player_id     :integer
#  fee           :integer
#  event_id      :integer
#  notes         :text
#  dir           :string           default("in")
#  add_on_clause :integer          default(0)
#

module MyFifa
  # Cost of Player Transfer/Exit
  class Cost < Base
    default_scope { order(id: :asc) }

    belongs_to :contract

    ######################
    #  ACCESSOR METHODS  #
    ######################
    include ActionView::Helpers::NumberHelper

    def total_fee
      transfer_fee = ''
      transfer_fee += number_to_fee(fee) if fee.present?

      if player_id.present?
        transfer_fee += ' + ' unless transfer_fee.blank?
        transfer_fee += player.shorthand_name
      end

      transfer_fee.blank? ? 'N/A' : transfer_fee
    end
  end
end
