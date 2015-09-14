class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name, :required => true
      t.string :model_number, :required => true, :unique => true
      t.text :description
      t.timestamps
    end

    add_index :products, [:model_number]
  end
end
