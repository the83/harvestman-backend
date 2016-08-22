class ImagePresenter < BasePresenter
  def attributes
    @object.image.model
  end
end
