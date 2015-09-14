require "product_presenter"

class Api::V1::ProductsController < ApplicationController
  CREATE_PARAMS_WHITELIST = [
    :model_number
  ]

  UPDATE_PARAMS_WHITELIST = [
    :name,
    :description
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
    product = Product.new(create_params)
    if product.save
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

  def update_params
    params.required(:product).permit(*UPDATE_PARAMS_WHITELIST)
  end

  def create_params
    whitelist = UPDATE_PARAMS_WHITELIST + CREATE_PARAMS_WHITELIST
    params.required(:product).permit(*whitelist)
  end
end
