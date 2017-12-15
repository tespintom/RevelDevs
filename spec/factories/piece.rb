FactoryBot.define do
  factory :piece do
    association :game
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
    association :game
    x 1
    y 2
  end
end
