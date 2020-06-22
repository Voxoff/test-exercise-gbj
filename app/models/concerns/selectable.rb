require 'active_support/concern'

module Selectable
  extend ActiveSupport::Concern

  included do
    def self.to_select
      pluck(:name, :id)
    end

    def self.to_select_with_price
      pluck("name || ' ' || price", :id)
    end
  end
end
