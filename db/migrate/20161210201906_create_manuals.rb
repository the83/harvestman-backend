class CreateManuals < ActiveRecord::Migration[4.2]
  def change
    create_table :manuals do |t|
      t.integer :product_id
      t.string :name, :required => true
      t.timestamps null: false
    end
  end
end
