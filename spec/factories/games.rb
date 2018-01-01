FactoryBot.define do
  factory :game do
    association :white_player, factory: :user 
    total_players 1
  end
end
