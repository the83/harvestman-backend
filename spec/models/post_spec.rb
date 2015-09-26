require 'rails_helper'
require "spec_helper"

describe Post do
  it "is persistable" do
    expect{
      Post.create({ permalink: "foo", content: "bar", title: "baz" })
    }.to change { Post.count }.by(1)
  end

  it "has tags" do
    post = Post.create({
      permalink: "foo",
      content: "bar",
      title: "baz",
      tag_list: ["tag1", "tag2"]
    })

    post.reload
    expect(post.tag_list).to eq(["tag1", "tag2"])
  end

  it "sanitizes the permalink" do
    Post.create({ permalink: "sOme Rand!om G@arbagE !!%^* #*", content: "bar", title: "baz" })
    page = Post.last
    expect(page.permalink).to eq("some-random-garbage")
  end

  it "requires a permalink" do
    expect{
      Post.create({ content: "foo", title: "bar" })
    }.to_not change { Post.count }
  end

  it "requires a permalink shorter than 30 chars" do
    long_permalink = "a" * 31
    expect{
      Post.create({ content: "foo", permalink: long_permalink, title: "bar" })
    }.to_not change { Post.count }
  end

  it "requires a unique permalink" do
    Post.create({ permalink: "first-permalink", content: "foo", title: "bar" })
    expect{
      Post.create({ permalink: "first-permalink", content: "foo", title: "bar" })
    }.to_not change { Post.count }
  end

  it "requires a title" do
    expect{
      Post.create({ permalink: "foo", content: "bar" })
    }.to_not change { Post.count }
  end

  it "requires content" do
    expect{
      Post.create({ permalink: "foo", title: "bar" })
    }.to_not change { Post.count }
  end
end
