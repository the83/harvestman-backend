class AddImagesToProducts < ActiveRecord::Migration[4.2]
  def change
    add_column :products, :images, :json
  end
end
