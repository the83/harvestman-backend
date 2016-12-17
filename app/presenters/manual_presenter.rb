class ManualPresenter < BasePresenter
  def attributes
    @object.manual.model
  end
end
