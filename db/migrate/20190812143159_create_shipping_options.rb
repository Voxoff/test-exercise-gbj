class CreateShippingOptions < ActiveRecord::Migration[5.2]
  def change
    create_table :shipping_options do |t|
      t.string :name
      t.float :price

      t.timestamps
    end
  end
end
