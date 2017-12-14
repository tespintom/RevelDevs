FactoryBot.define do
  factory :piece do
    association :game, factory: :games
    color :white
    x 1
    y 1
    captured false
  end

  factory :king, parent: :piece, class: 'King' do
    x 4
    y 1
  end

  factory :pawn, parent: :piece, class: 'Pawn' do
    x 1
    y 2
  end
end
