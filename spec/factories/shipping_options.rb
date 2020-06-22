FactoryBot.define do
  factory :shipping_option do
    trait :free do
      name { 'Free shipping' }
      price { 0 }
    end

    trait :premium do
      name { 'Premium shipping' }
      price { 2.50 }
    end
  end
end
