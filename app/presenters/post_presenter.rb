class PostPresenter < BasePresenter
  def attributes
    {
      id: @object.id,
      permalink: @object.permalink,
      title: @object.title,
      content: @object.content,
      tag_list: @object.tag_list
    }
  end
end
