require "rails_helper"
require "spec_helper"
require "page_presenter"

describe PostPresenter do
  it "presents a page" do
    page = Post.create!({
      title: "foo",
      content: "bar",
      permalink: "baz"
    })

    presented = ({
      id: page.id,
      permalink: page.permalink,
      title: page.title,
      content: page.content
    }).to_json

    expect(PostPresenter.new(page).to_json).to eq(presented)
  end
end
