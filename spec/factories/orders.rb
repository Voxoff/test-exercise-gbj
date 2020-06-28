FactoryBot.define do
  factory :order do
    state { 'billed' }
    recipient_name { "Guy" }
    first_delivery_date { Date.today }
    association :bouquet, :harper
    association :order_type, :single_delivery

    free_shipping

    trait :free_shipping do
      association :shipping_option, :free
    end

    trait :premium_shipping do
      association :shipping_option, :premium
    end


    factory :order_with_delivery do
      after(:create) do |order, evaluator|
        create_list(:delivery, 1, order: order)
      end
    end
  end
end
