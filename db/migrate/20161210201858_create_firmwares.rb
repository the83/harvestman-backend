class CreateFirmwares < ActiveRecord::Migration[4.2]
  def change
    create_table :firmwares do |t|
      t.integer :product_id
      t.string :name, :required => true
      t.string :description
      t.timestamps null: false
    end
  end
end
