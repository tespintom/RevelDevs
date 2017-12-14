FactoryBot.define do
  factory :game do
    association :user, factory: :users
  end
end
