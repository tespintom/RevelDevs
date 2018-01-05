FactoryBot.define do
  factory :game do
    association :user 
    total_players 1
  end
end
