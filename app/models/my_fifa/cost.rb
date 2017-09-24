module MyFifa
  class Cost < Base
    self.table_name = 'my_fifa_costs'

    belongs_to :player

    include ActionView::Helpers::NumberHelper

    def fee
      transfer_fee = ""
      transfer_fee += number_to_currency(self.price) if self.price.present?

      if self.player_id.present?
        transfer_fee += " + " unless transfer_fee.blank?
        transfer_fee += self.player.shorthand_name
      end

      transfer_fee.blank? ? 'N/A' : transfer_fee
    end
  end
end
