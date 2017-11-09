module MyFifa
  class Tournament < Competition
    
    ########################
    #  VALIDATION METHODS  #
    ########################
      validates :num_groups, numericality: { greater_than: 0, message: "Number of Groups must be greater than 0." }
      validates :num_advances_per_group, numericality: { greater_than: 0, message: "Teams Advancing per Group must be greater than 0." }
      validate :valid_num_teams_and_groups?
      
      def valid_num_teams_and_groups?
        if [self.num_teams, self.num_groups, self.num_advances_per_group].any?(&:blank?)
        elsif self.num_teams % self.num_groups != 0
          errors.add(:base, "Teams do not evenly divide into Groups.")
        elsif !multiple_of_two? self.num_groups * self.num_advances_per_group
          errors.add(:base, "Number of Teams remaining for the Elimination Rounds must be a multiple of 2.")
        end
      end
      
    ######################
    #  CALLBACK METHODS  #
    ######################
      after_create :build_tournament
      
      def build_tournament
        # Create Group Records
        self.num_teams.times do |i|
          self.results.create(group: ("A".ord + i % self.num_groups).chr)
        end
        
        # Create Fixtures
        (self.num_advances_per_group * self.num_groups - 1).times do
          self.fixtures.create
        end
      end
      
    ######################
    #  ACCESSOR METHODS  #
    ######################
      def rounds
        super(self.num_groups * self.num_advances_per_group)
      end

  end
end