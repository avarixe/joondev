class CreateMyFifaFixtures < ActiveRecord::Migration
  def change
    create_table :my_fifa_fixtures do |t|
      t.belongs_to :competition
      t.belongs_to :home_fixture
      t.belongs_to :away_fixture

      t.string :home_team
      t.string :away_team

      t.string :home_score
      t.string :away_score
    end
  end
end
