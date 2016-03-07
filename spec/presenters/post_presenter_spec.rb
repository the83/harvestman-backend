require "rails_helper"
require "spec_helper"
require "page_presenter"

describe PostPresenter do
  it "presents a post" do
    post = Post.create!({
      title: "foo",
      content: "bar",
      permalink: "baz",
      tag_list: ["tag1", "tag2"]
    })

    presented = ({
      id: post.id,
      permalink: post.permalink,
      title: post.title,
      content: post.content,
      tag_list: post.tag_list,
      images: []
    }).to_json

    expect(PostPresenter.new(post).to_json).to eq(presented)
  end
end
