namespace :cmsk do
  desc "Manually set fixture information using game information"
  task :set_fixtures_with_games => :environment do
    Cmsk::Game.all.map(&:set_fixture)
  end
end
