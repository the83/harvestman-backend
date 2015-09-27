class ProductPresenter < BasePresenter
  def attributes
    {
      id: @object.id,
      name: @object.name,
      model_number: @object.model_number,
      description: @object.description,
      manual: @object.manual,
      brief_description: @object.brief_description,
      tag_list: @object.tag_list,
      images: present_images(@object.images)
    }
  end

  private

  def present_images(images)
    images.map {|i| ImagePresenter.new(i) }
  end
end
