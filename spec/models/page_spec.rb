require "rails_helper"
require 'spec_helper'

describe Page do
  it "is persistable" do
    expect{
      Page.create({ permalink: "foo", content: "bar", title: "baz" })
    }.to change { Page.count }.by(1)
  end

  it "sanitizes the permalink" do
    Page.create({ permalink: "sOme Rand!om G@arbagE !!%^* #*", content: "bar", title: "baz" })
    page = Page.last
    page.permalink.should eq("some-random-garbage")
  end

  it "requires a permalink" do
    expect{
      Page.create({ content: "foo", title: "bar" })
    }.to_not change { Page.count }
  end

  it "requires a permalink shorter than 30 chars" do
    long_permalink = "a" * 31
    expect{
      Page.create({ content: "foo", permalink: long_permalink, title: "bar" })
    }.to_not change { Page.count }
  end

  it "requires a unique permalink" do
    Page.create({ permalink: "first-permalink", content: "foo", title: "bar" })
    expect{
      Page.create({ permalink: "first-permalink", content: "foo", title: "bar" })
    }.to_not change { Page.count }
  end

  it "requires a title" do
    expect{
      Page.create({ permalink: "foo", content: "bar" })
    }.to_not change { Page.count }
  end

  it "requires content" do
    expect{
      Page.create({ permalink: "foo", title: "bar" })
    }.to_not change { Page.count }
  end
end
