module MyFifa
  class PlayerEvent < Base
    self.table_name = 'my_fifa_player_events'
    default_scope { order(id: :asc) }

    belongs_to :player

    ######################
    #  CALLBACK METHODS  #
    ######################
      after_save -> { set_current_date(player.team, date_expires || date_effective) }
  end
end
