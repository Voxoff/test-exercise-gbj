class CreateBouquets < ActiveRecord::Migration[5.2]
  def change
    create_table :bouquets do |t|
      t.string :name
      t.float :price

      t.timestamps
    end
  end
end
