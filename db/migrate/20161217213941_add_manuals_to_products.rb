class AddManualsToProducts < ActiveRecord::Migration
  def change
    add_column :products, :manuals, :json
  end
end
