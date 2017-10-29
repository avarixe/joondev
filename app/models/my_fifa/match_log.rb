module MyFifa
  class MatchLog < Base
    default_scope { order(match_id: :asc, minute: :asc, id: :asc)}

    belongs_to :match, inverse_of: :logs
    belongs_to :player1, class_name: "Player"
    belongs_to :player2, class_name: "Player"

    EVENTS = [
      "Substitution",
      "Goal",
      "Booking",
      "Injury"
    ]

    validates :event, inclusion: { in: EVENTS }
    validates :player1_id, presence: true
    validates :minute, presence: true
    validate :valid_specific_event?

    def valid_specific_event?
      case self.event
      when "Substitution"
        errors.add(:player2_id, "Substitute Player can't be blank.") if self.player2_id.blank?
        errors.add(:notes, "Position can't be blank.") if self.notes.blank?
      when "Booking"
        errors.add(:notes, "Type of Booking is Invalid") unless ["Yellow Card", "Red Card"].include?(self.notes)
      when "Injury"
        errors.add(:notes, "Type of Injury can't be blank.") if self.notes.blank?
      end
    end

    def icon
      case self.event
      when "Substitution"
        "red level down"
      when "Booking"
        "#{self.notes == "Yellow Card" ? "yellow" : "red"} square"
      when "Goal"
        "soccer icon"
      when "Injury"
        "pink first aid"
      end      
    end

    def message
      case self.event
      when "Substitution"
        "#{self.player1.name} replaced by #{self.player2.name}"
      when "Booking"
        "#{self.player1.name} has received a #{self.notes}."
      when "Goal"
        "#{self.player1.name} scores! #{ "(assisted by #{self.player2.name})" if self.player2_id.present?}"
      when "Injury"
        "#{self.player1.name} injured with a #{self.notes}."        
      end
    end
  end
end
