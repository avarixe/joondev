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
  # BaseClass for Loans, Contracts, Injuries
  class PlayerEvent < Base
    default_scope { order(id: :asc) }

    belongs_to :player

    ######################
    #  CALLBACK METHODS  #
    ######################
    after_save -> { set_current_date(player.team, start_date) }
    after_commit -> { player.broadcast_change }
  end
end
