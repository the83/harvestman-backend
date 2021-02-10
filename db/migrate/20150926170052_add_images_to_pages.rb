class AddImagesToPages < ActiveRecord::Migration[4.2]
  def change
    add_column :pages, :images, :json
  end
end
