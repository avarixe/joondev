# == Schema Information
#
# Table name: my_fifa_match_logs
#
#  id         :integer          not null, primary key
#  match_id   :integer
#  event      :string
#  minute     :integer
#  player1_id :integer
#  player2_id :integer
#  notes      :text
#

module MyFifa
  # Match Events that log Goals, Substitutions, Injuries, Bookings
  class MatchLog < Base
    default_scope { order(match_id: :asc, minute: :asc, id: :asc) }

    belongs_to :match, inverse_of: :logs
    belongs_to :player1, class_name: 'Player'
    belongs_to :player2, class_name: 'Player'

    EVENTS = %w[
      Substitution
      Goal
      Booking
      Injury
    ].freeze

    ###################
    #  CLASS METHODS  #
    ###################
    def self.count_goals(logs, record)
      logs['Goal'].count { |log| record.player_id == log.player1_id }
    end

    def self.count_assists(logs, record)
      logs['Goal'].count { |log| record.player_id == log.player2_id }
    end

    def self.count_ycards(logs, record)
      logs['Booking'].count do |log|
        record.player_id == log.player1_id && log.notes == 'Yellow Card'
      end
    end

    def self.count_rcards(logs, record)
      logs['Booking'].count do |log|
        record.player_id == log.player1_id && log.notes == 'Red Card'
      end
    end

    def self.get_injury(logs, record)
      'injured' if logs['Injury'].any? do |log|
        record.player_id == log.player1_id
      end
    end

    ########################
    #  VALIDATION METHODS  #
    ########################
    validates :event, inclusion: { in: EVENTS }
    validates :player1_id, presence: true
    validates :minute, presence: true
    validate :valid_sub?, if: proc { |log| log.event == 'Substition' }
    validate :valid_booking?, if: proc { |log| log.event == 'Booking' }

    def valid_sub?
      if player2_id.blank?
        errors.add(:player2_id, 'Substitute Player can\'t be blank.')
      elsif notes.blank?
        errors.add(:notes, 'Position can\'t be blank.')
      end
    end

    def valid_booking?
      return unless event == 'Booking' &&
                    !['Yellow Card', 'Red Card'].include?(notes)
      errors.add(:notes, 'Type of Booking is Invalid')
    end

    ######################
    #  ACCESSOR METHODS  #
    ######################
    def icon
      case event
      when 'Substitution'
        'red level down'
      when 'Booking'
        "#{notes == 'Yellow Card' ? 'yellow' : 'red'} square"
      when 'Goal'
        'soccer icon'
      when 'Injury'
        'pink first aid'
      end
    end

    # rubocop:disable all
    def message
      case event
      when 'Substitution'
        "#{player1.name} replaced by #{player2.name}"
      when 'Booking'
        "#{player1.name} has received a #{notes}."
      when 'Goal'
        "#{player1.name} scores!#{" (assisted by #{player2.name})" if player2_id.present?}"
      when 'Injury'
        "#{player1.name} has been injured."
      end
    end
    # rubocop:enable all
  end
end
