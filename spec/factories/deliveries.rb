FactoryBot.define do
  factory :delivery do
    recipient_name { "Guy" }
    order
    association :bouquet, :harper
    association :shipping_option, :free
    delivery_date { Date.today}
  end
end
