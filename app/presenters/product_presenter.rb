class ProductPresenter < BasePresenter
  def attributes
    {
      id: @object.id,
      name: @object.name,
      model_number: @object.model_number,
      description: @object.description,
      manual: @object.manual,
      brief_description: @object.brief_description,
      tag_list: @object.tags.map(&:name),
      images: present_images(@object.images),
      features: @object.features,
      firmwares: present_firmwares(@object.firmwares),
      manuals: present_manuals(@object.manuals),
    }
  end

  private

  def present_images(images)
    images.order(created_at: :asc).map {|i| ImagePresenter.new(i) }
  end

  def present_firmwares(firmwares)
    firmwares.order(created_at: :asc).map {|i| FirmwarePresenter.new(i) }
  end

  def present_manuals(manuals)
    manuals.order(created_at: :asc).map {|i| ManualPresenter.new(i) }
  end
end
