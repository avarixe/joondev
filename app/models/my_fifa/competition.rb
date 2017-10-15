module MyFifa
  class Competition < Base
    belongs_to :team
    belongs_to :season

    ########################
    #  VALIDATION METHODS  #
    ########################
      validates :title,     presence: { message: "Competition can't be blank." }
      validates :type,      presence: { message: "Type must be specified." }
      validates :num_teams, presence: { message: "Number of Teams can't be blank." }
      validate  :unique_title_per_season?, on: :create
      validate  :valid_type_chosen?

      def unique_title_per_season?
        if self.title.present? && self.season.competition_options.include?(self.title)
          errors.add(:title, "Competition has already been added for this Season.")
        end
      end

      def valid_type_chosen?
        if self.type.present? && self.type != 'MyFifa::League'
          errors.add(:type, "Selected Type is Invalid.")
        end
      end

    ######################
    #  CALLBACK METHODS  #
    ######################

    #####################
    #  MUTATOR METHODS  #
    #####################

    ######################
    #  ACCESSOR METHODS  #
    ######################
  end
end
