class PostPresenter < BasePresenter
  def attributes
    {
      id: @object.id,
      permalink: @object.permalink,
      title: @object.title,
      content: @object.content,
      tag_list: @object.tag_list,
      images: present_images(@object.images),
      date: @object.created_at.in_time_zone(
        "Pacific Time (US & Canada)"
      ).strftime('%b %d, %Y')
    }
  end

  private

  def present_images(images)
    images.order(created_at: :asc).map {|i| ImagePresenter.new(i) }
  end
end
