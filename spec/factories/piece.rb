FactoryBot.define do
  factory :piece do
    association :game
    x 1
    y 1
  end
end
