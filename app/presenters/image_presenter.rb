class ImagePresenter < BasePresenter
  def attributes
    {
      id: @object.id,
      url: @object.image.url,
      type: @object.imageable_type.downcase,
      src: @object.image.url
    }
  end
end
