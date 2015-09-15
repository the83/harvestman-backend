class PagePresenter
  def initialize(page)
    @page = page
  end

  def attributes
    {
      id: @page.id,
      permalink: @page.permalink,
      title: @page.title,
      content: @page.content
    }
  end

  def as_json(options = nil)
    attributes
  end
end
