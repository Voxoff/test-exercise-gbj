class Order < ApplicationRecord
  belongs_to :bouquet
  belongs_to :order_type
  belongs_to :shipping_option

  has_many :deliveries, dependent: :destroy

  validates :recipient_name, :bouquet_id, :order_type_id,
    :shipping_option_id, :first_delivery_date, presence: true
end
