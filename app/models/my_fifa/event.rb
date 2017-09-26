module MyFifa
  class Event < Base
    self.abstract_class = true

    belongs_to :player

    ######################
    #  CALLBACK METHODS  #
    ######################
      after_save -> { set_current_date(player.team, date_expires || date_effective) }
  end
end
