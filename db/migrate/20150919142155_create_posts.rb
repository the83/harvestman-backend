class CreatePosts < ActiveRecord::Migration[4.2]
  def change
    create_table :posts do |t|
      t.string :permalink
      t.string :title
      t.text :content

      t.timestamps null: false
    end
  end
end
