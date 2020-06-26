FactoryBot.define do
  factory :order do
    state { 'billed' }
    first_delivery_date { Date.today }
    association :bouquet, :harper
    association :shipping_option, :free
    association :order_type, :single_delivery
    recipient_name { "Guy" }

    factory :order_with_delivery do
      after(:create) do |order, evaluator|
        create_list(:delivery, 1, order: order)
      end
    end
  end
end
