# == Schema Information
#
# Table name: my_fifa_formations
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  title      :string
#  layout     :string
#  pos_1      :string
#  pos_2      :string
#  pos_3      :string
#  pos_4      :string
#  pos_5      :string
#  pos_6      :string
#  pos_7      :string
#  pos_8      :string
#  pos_9      :string
#  pos_10     :string
#  pos_11     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

module MyFifa
  # Formation meta for Squads
  class Formation < Base
    default_scope { order(title: :asc, id: :asc) }

    belongs_to :user
    has_many :squads

    ########################
    #  VALIDATION METHODS  #
    ########################
    validate :all_positions_labeled?

    def all_positions_labeled?
      return unless positions.any?(&:blank?)
      errors.add(:base, 'Not all Positions are labeled.')
    end

    ######################
    #  CALLBACK METHODS  #
    ######################
    after_create :set_title

    def set_title
      num_layouts = Formation.where(user_id: user_id, layout: layout).count
      self.title = layout
      self.title += " (#{num_layouts})" if num_layouts > 1
      save
    end

    ######################
    #  ACCESSOR METHODS  #
    ######################
    def positions
      (1..11).map { |no| send("pos_#{no}") }
    end

    def layout_to_a
      rows = []
      pos = Array(2..11).reverse
      layout.split('-').map(&:to_i).each do |num_pos|
        rows << []
        num_pos.times do
          rows.last << pos.pop
        end
      end
      rows.reverse
    end
  end
end
