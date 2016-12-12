class CreateFirmwares < ActiveRecord::Migration
  def change
    create_table :firmwares do |t|
      t.integer :product_id
      t.string :name, :required => true
      t.string :description
      t.timestamps null: false
    end
  end
end
