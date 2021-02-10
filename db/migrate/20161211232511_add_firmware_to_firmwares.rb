class AddFirmwareToFirmwares < ActiveRecord::Migration[4.2]
  def change
    add_column :firmwares, :firmware, :string
  end
end
