class AddImagesToPosts < ActiveRecord::Migration[4.2]
  def change
    add_column :posts, :images, :json
  end
end
