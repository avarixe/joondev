module MyFifa
  class PlayerSeason < Base
    default_scope { order(id: :asc) }
    
    belongs_to :season
    belongs_to :player
    
    validates :kit_no, numericality: { greater_than_or_equal_to: 0 }
    validates :age,    numericality: { greater_than_or_equal_to: 0 }
    validates :ovr,    numericality: { greater_than_or_equal_to: 0 }
    validates :value,  numericality: { greater_than_or_equal_to: 0 }

    def formatted_value
      number_to_fee self.value
    end
    
    def value=(val)
      case val
      when /^(\d+(\.\d+)?)[Kk]$/
        write_attribute :value, $1.to_f * 1000
      when /^(\d+(\.\d+)?)[Mm]$/
        write_attribute :value, $1.to_f * 1000000
      else
        write_attribute :value, val
      end
    end
  end
end
