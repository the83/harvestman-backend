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

  def create_params
    params.required(:manual)
  end

  def convert_to_upload(file)
    temp_file = file.tempfile
    temp_file.binmode
    temp_file.rewind

    ActionDispatch::Http::Uploadedfirmware.new({
      manualname: manual.original_filename,
      type: file.content_type,
      tempmanual: temp_file
    })
  end
end
