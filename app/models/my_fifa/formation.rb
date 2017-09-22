module MyFifa
  class Formation < Base
    self.table_name = 'my_fifa_formations'

    validates :title, presence: { message: 'Title cannot be blank.' }
    validate :all_positions_labeled?

    belongs_to :user
    has_many :squads

    LAYOUTS = [
      '3-1-2-1-3',
      '3-1-4-2',
      '3-4-1-2',
      '3-4-2-1',
      '3-4-3',

      '4-1-2-1-2',
      '4-1-2-3',
      '4-1-3-2',
      '4-2-1-3',
      '4-2-2-2',
      '4-2-3-1',
      '4-2-4',
      '4-3-1-2',
      '4-3-2-1',
      '4-3-3',
      '4-4-2',
    ]

    def all_positions_labeled?
      if positions.any? { |pos| pos.blank? }
        self.errors.add(:base, "Not all Positions are labeled.");
      end
    end

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
