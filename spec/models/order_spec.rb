require 'rails_helper'

RSpec.describe Order, type: :model do
  it { should validate_presence_of(:recipient_name) }
  it { should validate_presence_of(:bouquet_id) }
  it { should validate_presence_of(:order_type_id) }
  it { should validate_presence_of(:shipping_option_id) }
  it { should validate_presence_of(:first_delivery_date) }
end
