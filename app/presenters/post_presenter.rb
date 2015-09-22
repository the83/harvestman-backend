class PostPresenter < BasePresenter
  def attributes
    {
      id: @object.id,
      permalink: @object.permalink,
      title: @object.title,
      content: @object.content
    }
  end
end
