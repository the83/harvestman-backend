class CreatePages < ActiveRecord::Migration[4.2]
  def change
    create_table :pages do |t|
      t.string :permalink
      t.string :title
      t.text :content

      t.timestamps
    end
  end
end
