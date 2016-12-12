# encoding: utf-8
require 'fog/aws'

class FirmwareUploader < CarrierWave::Uploader::Base
  storage :fog

  def extension_white_list
    %w(zip)
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
end
