class AddFirmwareToFirmwares < ActiveRecord::Migration
  def change
    add_column :firmwares, :firmware, :string
  end
end
