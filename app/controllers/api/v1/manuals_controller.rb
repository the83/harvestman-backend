class Api::V1::ManualsController < ApplicationController
  before_filter :authorize_user!

  PARAMS_WHITELIST = [
    :manual
  ].freeze

  def create
    manual = Manual.create(prepared_params)
    render({ json: { manual: ManualPresenter.new(manual) } }) and return
  end

  def destroy
    manual = Manual.find_by_id(params[:id])
    head 204 if (manual.destroy!)
  end

  private

  def prepared_params
    manual_params = { manual: params[:manual] }
    parent_params = { product_id: params[:parent_id] }
    manual_params.merge!(parent_params) if params[:parent_id]
    manual_params
  end
end
