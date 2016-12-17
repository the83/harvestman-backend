class AddManualToManuals < ActiveRecord::Migration
  def change
    add_column :manuals, :manual, :string
  end
end
