class Firmware < ActiveRecord::Base
  belongs_to :product
  mount_uploader :firmware, FirmwareUploader
end
