class AddBriefDescriptionToProduct < ActiveRecord::Migration
  def change
    add_column :products, :brief_description, :string
  end
end
