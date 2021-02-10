class CreateInstruments < ActiveRecord::Migration[4.2]
  def change
    create_table :instruments do |t|
      t.string :name, :required => true
      t.string :permalink
      t.text :description
      t.string :brief_description

      t.timestamps null: false
    end
  end
end
