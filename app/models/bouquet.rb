class Bouquet < ApplicationRecord
  include Selectable

  validates :name, :price, presence: true
  validates :price, numericality: { greater_than: 0 }

  def to_s
    name
  end
end
