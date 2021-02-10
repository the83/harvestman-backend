class RemoveImageColumns < ActiveRecord::Migration[4.2]
  def change
    remove_column :products, :images
    remove_column :pages, :images
    remove_column :posts, :images
  end
end
