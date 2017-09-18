module MyFifa
  class PlayerRecord < Base
    self.table_name = 'my_fifa_player_records'
    belongs_to :team
    belongs_to :fixture
    belongs_to :player

    scope :with_player, -> {
      joins('LEFT JOIN my_fifa_players ON my_fifa_player_records.player_id = my_fifa_players.id')
        .select([
          'my_fifa_player_records.*',
          'my_fifa_players.name as player_name'
        ].join(', ') )
    }

    scope :exclusively, -> (ids) {
      where(id: ids)
    }

    validates_presence_of :player_id, :rating, :pos
  end
end
