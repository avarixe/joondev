module MyFifa
  class Cost < Base
    default_scope { order(id: :asc)}

    belongs_to :player


    #####################
    #  MUTATOR METHODS  #
    #####################

    ######################
    #  ACCESSOR METHODS  #
    ######################
      include ActionView::Helpers::NumberHelper

      def total_fee
        transfer_fee = ""
        transfer_fee += number_to_currency(self.fee) if self.fee.present?

        if self.player_id.present?
          transfer_fee += " + " unless transfer_fee.blank?
          transfer_fee += self.player.shorthand_name
        end

        transfer_fee.blank? ? 'N/A' : transfer_fee
      end
  end
end
