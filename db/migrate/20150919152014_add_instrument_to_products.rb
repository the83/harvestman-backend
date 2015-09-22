class AddInstrumentToProducts < ActiveRecord::Migration
  def change
    add_reference :products, :instrument, index: true, foreign_key: true
  end
end
