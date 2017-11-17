# == Schema Information
#
# Table name: my_fifa_squads
#
#  id           :integer          not null, primary key
#  team_id      :integer
#  squad_name   :string           not null
#  player_id_1  :integer
#  player_id_2  :integer
#  player_id_3  :integer
#  player_id_4  :integer
#  player_id_5  :integer
#  player_id_6  :integer
#  player_id_7  :integer
#  player_id_8  :integer
#  player_id_9  :integer
#  player_id_10 :integer
#  player_id_11 :integer
#  formation_id :integer
#

module MyFifa
  # Presets of 11 Players
  class Squad < Base
    default_scope { order(id: :asc) }

    belongs_to :team
    belongs_to :formation

    ########################
    #  VALIDATION METHODS  #
    ########################
    validates :squad_name, presence: { message: 'Squad Name can\'t be blank.' }
    validate :all_pos_filled?
    validate :unique_players?

    def all_pos_filled?
      (1..11).each do |n|
        next unless send("player_id_#{n}").blank?
        errors.add(
          "player_id_#{n}",
          "#{formation.public_send("pos_#{n}")} is unselected."
        )
      end
    end

    def unique_players?
      return unless player_ids.any? { |id| player_ids.count(id) > 1 }
      errors.add(
        :base,
        'One Player has been assigned to at least two Positions.'
      )
    end

    ######################
    #  ACCESSOR METHODS  #
    ######################
    def player_ids
      (1..11).map { |n| send("player_id_#{n}") }
    end

    def players
      Player.unscoped do
        Player.find(player_ids.compact).sort_by do |player|
          player_ids.index(player.id)
        end
      end
    end

    def player_names
      players.map(&:name).join(', ')
    end
  end
end
