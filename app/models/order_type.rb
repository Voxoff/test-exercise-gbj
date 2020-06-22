class OrderType < ApplicationRecord
  include Selectable

  validates :name, presence: true

  def to_s
    name
  end
end
