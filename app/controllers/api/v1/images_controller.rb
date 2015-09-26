require "product_presenter"

class Api::V1::ImagesController < ApplicationController
  PARAMS_WHITELIST = [
    :image
  ].freeze

  def index
    head 404 unless parent
    render({ json: { images: parent.images } })
  end

  def create
    head 404 unless parent
    image = convert_to_upload(params[:image])
    parent.images << image
    render({ json: { image: image })

    # if product.save
    #   render({ json: { product: ProductPresenter.new(product) } })
    # else
    #   render({ status: 400, json: {
    #     status: 400, error: "Error creating product." } })
    # end
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
    image_data = split_base64(image[:data])

    temp_img_file = Tempfile.new("data_uri-upload")
    temp_img_file.binmode
    temp_img_file << Base64.decode64(image_data[:data])
    temp_img_file.rewind

    ActionDispatch::Http::UploadedFile.new({
      filename: image[:filename],
      type: image[:type],
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
