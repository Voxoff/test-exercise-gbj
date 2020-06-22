class ShippingOption < ApplicationRecord
  include Selectable

  validates :name, :price, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }

  def to_s
    name
  end
end
