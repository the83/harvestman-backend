class AddImagesToPages < ActiveRecord::Migration
  def change
    add_column :pages, :images, :json
  end
end
