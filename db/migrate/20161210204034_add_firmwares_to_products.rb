class AddFirmwaresToProducts < ActiveRecord::Migration
  def change
    add_column :products, :firmwares, :json
  end
end
