FactoryBot.define do
  factory :game do
    total_players 1
    association :user
  end
end
