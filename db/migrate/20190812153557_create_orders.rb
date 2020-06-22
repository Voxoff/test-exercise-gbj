class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.string :recipient_name
      t.references :bouquet, index: true
      t.references :order_type, index: true
      t.references :shipping_option, index: true
      t.date :first_delivery_date
      t.string :state, default: 'billed'

      t.timestamps
    end
  end
end
