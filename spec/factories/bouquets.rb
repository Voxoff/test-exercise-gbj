FactoryBot.define do
  factory :bouquet do
    trait :harper do
      name { 'Harper' }
      price { 35.00 }
    end

    trait :alexa do
      name { 'Alexa' }
      price { 35.00 }
    end

    trait :adrian do
      name { 'Adrian' }
      price { 40.00 }
    end
  end
end
