class InstrumentPresenter < BasePresenter
  def attributes
    {
      id: @object.id,
      permalink: @object.permalink,
      name: @object.name,
      description: @object.description,
      brief_description: @object.brief_description
    }
  end
end
