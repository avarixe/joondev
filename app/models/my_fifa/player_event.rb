module MyFifa
  class PlayerEvent < Base
    default_scope { order(id: :asc) }

    belongs_to :player

    ######################
    #  CALLBACK METHODS  #
    ######################
      after_save -> { set_current_date(player.team, end_date || start_date) }
  end
end
