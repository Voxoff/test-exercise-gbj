class Order < ApplicationRecord
  belongs_to :bouquet
  belongs_to :order_type
  belongs_to :shipping_option

  has_many :deliveries, dependent: :destroy

  validates :recipient_name, :bouquet_id, :order_type_id,
    :shipping_option_id, :first_delivery_date, presence: true

  def self.create_deliveries_on(date)
    # Get orders created on a certain day, with a billed state, which do not already have deliveries
    orders = Order.includes(:bouquet, :shipping_option, :order_type)
                  .where(:created_at => date.beginning_of_day..date.end_of_day, state: 'billed')
                  .left_joins(:deliveries)
                  .merge(Delivery.where(id: nil))

    orders.each do |order|
      order_hash = { order: order, delivery_date: date, bouquet: order.bouquet, recipient_name: order.recipient_name, shipping_option: order.shipping_option }
      Delivery.transaction do
        Delivery.create(order_hash)
        order.update(state: 'complete')
      end
    end
  end
end
