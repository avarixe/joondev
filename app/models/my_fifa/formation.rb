module MyFifa
  class Formation < Base
    default_scope { order(id: :asc)}

    belongs_to :user
    has_many :squads

    ############################
    #  INITIALIZATION METHODS  #
    ############################


    ########################
    #  ASSIGNMENT METHODS  #
    ########################


    ########################
    #  VALIDATION METHODS  #
    ########################
      validate :all_positions_labeled?

      def all_positions_labeled?
        if positions.any? { |pos| pos.blank? }
          self.errors.add(:base, "Not all Positions are labeled.");
        end
      end

    ######################
    #  CALLBACK METHODS  #
    ######################
      after_create :set_title
      
      def set_title
        num_layouts = Formation.where(user_id: self.user_id, layout: self.layout).count
        self.title = self.layout
        self.title += " (#{num_layouts})" if num_layouts > 0
        self.save
      end

    #####################
    #  MUTATOR METHODS  #
    #####################

    ######################
    #  ACCESSOR METHODS  #
    ######################
      def positions
        (1..11).map{ |no| self.send("pos_#{no}") }
      end

      def layout_to_a
        rows = []
        pos = Array(2..11).reverse
        layout.split("-").map(&:to_i).each do |num_pos|
          rows << []
          num_pos.times do
            rows.last << pos.pop
          end
        end
        rows.reverse
      end
  end
end
