require 'rails_helper'

RSpec.describe Bouquet, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:price) }

  it { should validate_numericality_of(:price).is_greater_than(0) }
end
