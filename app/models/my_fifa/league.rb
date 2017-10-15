module MyFifa
  class League < Competition
    has_many :results, class_name: 'LeagueResult', inverse_of: :league
    accepts_nested_attributes_for :results

    after_create :build_results

    def build_results
      self.num_teams.times do
        self.results.create
      end
    end
  end
end