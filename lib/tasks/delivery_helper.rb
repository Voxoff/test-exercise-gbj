require_relative '../../config/environment'

class DeliveryHelper
  attr_reader :date
  attr_accessor :first_available_free_date

  def initialize(date:)
    @date = date
    @first_available_free_date = date
    calculate_available_day
  end

  def create_deliveries
    orders_to_deliver.each do |order|
      order_hash = { order: order, delivery_date: delivery_date(order), bouquet: order.bouquet, recipient_name: order.recipient_name, shipping_option: order.shipping_option }
      Delivery.transaction do
        Delivery.create(order_hash)
        order.update(state: 'complete')
      end
    end
  end

  def delivery_date(order)
    order.shipping_option.name == 'Free shipping' ? first_available_free_date : date
  end

  def orders_to_deliver
    # Get orders created on a certain day, with a billed state, which do not already have deliveries
    orders = Order.includes(:bouquet, :shipping_option, :order_type)
                  .where(first_delivery_date: date, state: 'billed')
                  .left_joins(:deliveries)
                  .merge(Delivery.where(id: nil))
  end

  def calculate_available_day
    while bank_holidays.include?(first_available_free_date)
      self.first_available_free_date += 1.day
    end
  end

  def bank_holidays
    html = File.read(bank_holiday_file)
    json = JSON.parse(html)
    bank_holidays = json.map { |string_date| Date.parse(string_date['date']) }
    if date + 1.month >= bank_holidays.last
      raise ArgumentError, 'Out of date. Check: https://www.gov.uk/bank-holidays.json'
    end
    bank_holidays
  end

  def bank_holiday_file
    Rails.root.join('lib', 'assets', 'england_and_wales_bank_holidays.json')
  end
end
