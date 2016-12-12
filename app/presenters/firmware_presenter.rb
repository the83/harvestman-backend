class FirmwarePresenter < BasePresenter
  def attributes
    @object.firmware.model
  end
end
