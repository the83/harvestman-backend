class AddManualToProduct < ActiveRecord::Migration
  def change
    add_column :products, :manual, :text
  end
end
