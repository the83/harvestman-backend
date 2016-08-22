require "product_presenter"

class Api::V1::ProductsController < ApplicationController
  UPDATE_PARAMS_WHITELIST = [
    :name,
    :description,
    :brief_description,
    :model_number,
    :manual,
    :features,
    tag_list: [],
    images_attributes: [:id, :image],
  ].freeze

  def show
    product = Product.find_by_id(params[:id])
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
    product = Product.new(create_params.except(:images_attributes))

    if product.save
      build_images_for(product)
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
    return if images_attributes.blank?
    images_attributes = create_params.slice(:images_attributes)
    images_attributes["images_attributes"].each do |p|
      model.images << Image.find_by_id(p["id"])
    end
  end

  def update_params
    params.required(:product).permit(*UPDATE_PARAMS_WHITELIST)
  end

  def create_params
    params.required(:product).permit(*UPDATE_PARAMS_WHITELIST)
  end
end
