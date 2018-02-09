FactoryBot.define do
  factory :piece do
    color :white
    x 1
    y 1
    captured false
  end

  factory :king, parent: :piece, class: 'King' do
    x 5
    y 1
  end

  factory :pawn, parent: :piece, class: 'Pawn' do
    x 1
    y 2
  end

  factory :rook, parent: :piece, class: 'Rook' do
    x 1
    y 1
  end

  factory :bishop, parent: :piece, class: 'Bishop' do
    x 3
    y 1
  end

  factory :knight, parent: :piece, class: 'Knight' do
    x 2
    y 1
  end

  factory :queen, parent: :piece, class: 'Queen' do
    x 4
    y 1
  end
end
