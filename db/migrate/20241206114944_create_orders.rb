class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.string :name
      t.integer :quantity
      t.integer :price
      t.text :description

      t.timestamps
    end
  end
end
