class AddManualToProduct < ActiveRecord::Migration[4.2]
  def change
    add_column :products, :manual, :text
  end
end
