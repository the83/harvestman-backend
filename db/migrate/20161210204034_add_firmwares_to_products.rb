class AddFirmwaresToProducts < ActiveRecord::Migration[4.2]
  def change
    add_column :products, :firmwares, :json
  end
end
