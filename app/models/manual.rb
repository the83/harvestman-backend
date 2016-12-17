class Manual < ActiveRecord::Base
  belongs_to :product
  mount_uploader :manual, ManualUploader
end
