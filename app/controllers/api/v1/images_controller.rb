require "product_presenter"

class Api::V1::ImagesController < ApplicationController
  PARAMS_WHITELIST = [
    :image
  ].freeze

  def create
    head 404 unless parent
    image = Image.create(image: params[:image])
    parent.images << image
    if parent.save!
      render({ json: { image: ImagePresenter.new(image) } })
    end
  end

  def destroy
    head 404 unless parent
    # product = Product.find_by_id(params[:id])
    # product.destroy!
    # head 204
  end

  private

  def parent
    case
      when params[:product_id] then Product.find_by_id(params[:product_id])
      when params[:instrument_id] then Product.find_by_id(params[:instrument_id])
      when params[:post_id] then Product.find_by_id(params[:post_id])
      when params[:page_id] then Product.find_by_id(params[:page_id])
    end
  end

  def create_params
    params.required(:image)
  end

  def convert_to_upload(image)
    # image_data = split_base64(image)

    temp_img_file = image.tempfile
    temp_img_file.binmode
    temp_img_file.rewind
    # temp_img_file << Base64.decode64(image.tempfile)
    # temp_img_file.rewind

    ActionDispatch::Http::UploadedFile.new({
      filename: image.original_filename,
      type: image.content_type,
      tempfile: temp_img_file
    })
  end

  def split_base64(uri_str)
    if uri_str.match(%r{^data:(.*?);(.*?),(.*)$})
      uri = Hash.new
      uri[:type] = $1 # "image/gif"
      uri[:encoder] = $2 # "base64"
      uri[:data] = $3 # data string
      uri[:extension] = $1.split('/')[1] # "gif"
      return uri
    end
  end
end
