# encoding: utf-8
require 'fog/aws'

class ImageUploader < CarrierWave::Uploader::Base
  storage :fog

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
end
