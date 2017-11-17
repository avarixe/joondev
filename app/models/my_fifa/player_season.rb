# == Schema Information
#
# Table name: my_fifa_player_seasons
#
#  id        :integer          not null, primary key
#  season_id :integer
#  player_id :integer
#  kit_no    :integer
#  value     :integer
#  ovr       :integer
#  age       :integer          default(0)
#

module MyFifa
  # Season Data of a Player
  class PlayerSeason < Base
    default_scope { order(id: :asc) }

    belongs_to :season
    belongs_to :player

    validates :kit_no, numericality: { greater_than_or_equal_to: 0 }
    validates :age,    numericality: { greater_than_or_equal_to: 0 }
    validates :ovr,    numericality: { greater_than_or_equal_to: 0 }
    validates :value,  numericality: { greater_than_or_equal_to: 0 }

    def formatted_value
      number_to_fee value
    end

    def value=(val)
      case val
      when /^(\d+(\.\d+)?)[Kk]$/
        write_attribute :value, Regexp.last_match[1].to_f * 1_000
      when /^(\d+(\.\d+)?)[Mm]$/
        write_attribute :value, Regexp.last_match[1].to_f * 1_000_000
      else
        write_attribute :value, val
      end
    end
  end
end
