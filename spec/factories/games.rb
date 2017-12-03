FactoryBot.define do
  factory :game do
    association :black_player, factory: :player
    association :white_player, factory: :player
  end
end
