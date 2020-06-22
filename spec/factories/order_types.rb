FactoryBot.define do
  factory :order_type do
    trait :single_delivery do
      name { 'Single delivery' }
    end

    trait :three_month_bundle do
      name { '3 month bundle' }
    end
  end
end
