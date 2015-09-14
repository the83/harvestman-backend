class ProductPresenter
  def initialize(product)
    @product = product
  end

  def attributes
    {
      id: @product.id,
      name: @product.name,
      model_number: @product.model_number,
      description: @product.description
    }
  end

  def as_json(options = nil)
    attributes
  end
end
