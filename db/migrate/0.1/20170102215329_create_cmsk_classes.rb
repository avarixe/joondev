class CreateCmskClasses < ActiveRecord::Migration
  def change
    Cmsk::Base.connection.create_table :cmsk_teams do |t|
      t.belongs_to :user
      t.string :team_name
      t.string :competitions

      t.timestamps null: false
    end
    
    Cmsk::Base.connection.create_table :cmsk_players do |t|
      t.belongs_to :team
      t.string :name, null: false
      t.string :pos, null: false
      t.string :sec_pos
      t.boolean :active, default: true

      t.timestamps null: false
    end

    Cmsk::Base.connection.create_table :cmsk_games do |t|
      t.belongs_to :team
      t.string :opponent, null: false
      t.string :competition, null: false
      t.integer :score_gf, null: false
      t.integer :score_ga, null: false
      t.integer :penalties_gf
      t.integer :penalties_ga
      t.date :date_played
    end
    
    Cmsk::Base.connection.create_table :cmsk_player_records do |t|
      t.belongs_to :team
      t.belongs_to :game
      t.belongs_to :player
      
      t.float :rating
      t.integer :goals
      t.integer :assists
    end

    Cmsk::Base.connection.create_table :cmsk_squads do |t|
      t.belongs_to :team
      t.string :squad_name, null: false
      
      t.integer  :player_id_1
      t.integer  :player_id_2
      t.integer  :player_id_3
      t.integer  :player_id_4
      t.integer  :player_id_5
      t.integer  :player_id_6
      t.integer  :player_id_7
      t.integer  :player_id_8
      t.integer  :player_id_9
      t.integer  :player_id_10
      t.integer  :player_id_11
    end
  end
end
