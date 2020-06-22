class Delivery < ApplicationRecord
  belongs_to :order
  belongs_to :bouquet
  belongs_to :shipping_option

  validates :recipient_name, :bouquet_id, :order_id,
    :shipping_option_id, :delivery_date, presence: true
end
