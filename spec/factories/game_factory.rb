FactoryGirl.define do
  factory :game do
    name { Faker::Lorem.words(1) }
  end
end
