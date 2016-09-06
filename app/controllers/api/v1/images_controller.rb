require "product_presenter"

class Api::V1::ImagesController < ApplicationController
  PARAMS_WHITELIST = [
    :image
  ].freeze

  def create
    image = Image.create(prepared_params)
    render({ json: { image: ImagePresenter.new(image) } }) and return
  end

  def destroy
    image = Image.find_by_id(params[:id])
    head 204 if (image.destroy!)
  end

  private

  def prepared_params
    image_params = { image: params[:image] }
    parent_params = {
      imageable_id: params[:parent_id],
      imageable_type: params[:parent_type]
    }
    image_params.merge!(parent_params) if params[:parent_id]
    image_params
  end

  def create_params
    params.required(:image)
  end

  def convert_to_upload(image)
    temp_img_file = image.tempfile
    temp_img_file.binmode
    temp_img_file.rewind

    ActionDispatch::Http::UploadedFile.new({
      filename: image.original_filename,
      type: image.content_type,
      tempfile: temp_img_file
    })
  end
end
