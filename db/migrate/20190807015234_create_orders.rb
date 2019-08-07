class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.integer :itemId
      t.string :description
      t.integer :customerId
      t.float :price
      t.float :award

      t.timestamps
    end
  end
end
