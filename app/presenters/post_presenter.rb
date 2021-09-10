class PostPresenter < BasePresenter
  TIME_ZONE = "Pacific Time (US & Canada)".freeze
  TIME_FORMAT = "%b %d, %Y".freeze

  def attributes
    {
      id: @object.id,
      permalink: @object.permalink,
      title: @object.title,
      content: @object.content,
      tag_list: @object.tags.map(&:name),
      images: present_images(@object.images),
      date: @object.created_at
        .in_time_zone(TIME_ZONE)
        .strftime(TIME_FORMAT)
    }
  end

  private

  def present_images(images)
    images.map {|i| ImagePresenter.new(i) }
  end
end
