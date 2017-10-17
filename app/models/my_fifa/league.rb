module MyFifa
  class League < Competition
    
    ######################
    #  CALLBACK METHODS  #
    ######################
      after_create :build_results
  
      def build_results
        self.num_teams.times do
          self.results.create
        end
      end
  end
end