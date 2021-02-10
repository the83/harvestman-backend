class AddFeaturesToProducts < ActiveRecord::Migration[4.2]
  def change
    add_column :products, :features, :text
  end
end
