class AddBriefDescriptionToProduct < ActiveRecord::Migration[4.2]
  def change
    add_column :products, :brief_description, :string
  end
end
