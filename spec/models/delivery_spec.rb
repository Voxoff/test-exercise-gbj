require 'rails_helper'

RSpec.describe Delivery, type: :model do
  it { should validate_presence_of(:recipient_name) }
  it { should validate_presence_of(:bouquet_id) }
  it { should validate_presence_of(:order_id) }
  it { should validate_presence_of(:shipping_option_id) }
  it { should validate_presence_of(:delivery_date) }
end
