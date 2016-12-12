require "product_presenter"

class Api::V1::ProductsController < ApplicationController
  before_filter :authorize_user!, only: [:update, :create, :destroy]
  respond_to :json

  def show
    product = Product.find_by_id(params[:id])
    return head 404 unless product

    render({ json: { product: ProductPresenter.new(product) } })
  end

  def index
    products = Product.all
    presented_products = products.map { |p| ProductPresenter.new(p) }
    render({ json: { products: presented_products } })
  end

  def update
    product = Product.find_by_id(params[:id])
    product.update_attributes!(update_params)
    render({ json: { product: ProductPresenter.new(product) } })
  end

  def create
    product = Product.new(update_params.except(:images_attributes, :firmwares_attributes))

    if product.save
      build_images_for(product)
      build_firmwares_for(product)
      render({ json: { product: ProductPresenter.new(product) } })
    else
      render({ status: 400, json: {
        status: 400, error: "Error creating product." } })
    end
  end

  def destroy
    product = Product.find_by_id(params[:id])
    product.destroy!
    head 204
  end

  private

  def build_images_for(model)
    images_attributes = update_params.slice(:images_attributes)
    return if images_attributes.blank?
    images_attributes["images_attributes"].each do |p|
      model.images << Image.find_by_id(p["id"])
    end
  end

  def build_firmwares_for(model)
    firmwares_attributes = update_params.slice(:firmwares_attributes)
    return if firmwares_attributes.blank?
    firmwares_attributes["firmwares_attributes"].each do |p|
      firmware = Firmware.find_by_id(p["id"])
      firmware.name = p["name"]
      model.firmwares << firmware
    end
  end

  def update_params
    params.required(:product).permit(
      :name,
      :description,
      :brief_description,
      :model_number,
      :manual,
      :features,
      tag_list: [],
      images_attributes: [],
      :firmwares_attributes => [:id, :name],
    )
  end
end
