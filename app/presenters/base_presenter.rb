class BasePresenter
  def initialize(object)
    @object = object
  end

  def as_json(options = nil)
    attributes
  end

  def attributes
    {}
  end
end
