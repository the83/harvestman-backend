class Api::V1::FirmwaresController < ApplicationController
  before_filter :authorize_user!

  PARAMS_WHITELIST = [
    :firmware
  ].freeze

  def create
    firmware = Firmware.create(prepared_params)
    render({ json: { firmware: FirmwarePresenter.new(firmware) } }) and return
  end

  def destroy
    firmware = Firmware.find_by_id(params[:id])
    head 204 if (firmware.destroy!)
  end

  private

  def prepared_params
    firmware_params = { firmware: params[:firmware] }
    parent_params = { product_id: params[:parent_id] }
    firmware_params.merge!(parent_params) if params[:parent_id]
    firmware_params
  end

  def create_params
    params.required(:firmware)
  end

  def convert_to_upload(file)
    temp_file = file.tempfile
    temp_file.binmode
    temp_file.rewind

    ActionDispatch::Http::Uploadedfirmware.new({
      firmwarename: firmware.original_filename,
      type: file.content_type,
      tempfirmware: temp_file
    })
  end
end
