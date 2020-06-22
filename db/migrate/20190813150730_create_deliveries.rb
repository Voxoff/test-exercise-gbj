class CreateDeliveries < ActiveRecord::Migration[5.2]
  def change
    create_table :deliveries do |t|
      t.string :recipient_name
      t.references :bouquet, index: true
      t.references :shipping_option, index: true
      t.references :order, index: true
      t.date :delivery_date

      t.timestamps
    end
  end
end
