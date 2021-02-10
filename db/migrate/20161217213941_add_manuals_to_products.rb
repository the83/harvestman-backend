class AddManualsToProducts < ActiveRecord::Migration[4.2]
  def change
    add_column :products, :manuals, :json
  end
end
