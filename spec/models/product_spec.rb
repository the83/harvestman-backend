require "rails_helper"
require "spec_helper"

describe Product do
  it "exists" do
    product = Product.create!({
      name: "foo",
      model_number: "bar",
      description: "baz"
    })

    product.reload
    expect(product.name).to eq("foo")
    expect(product.model_number).to eq("bar")
    expect(product.description).to eq("baz")
  end

  it "requires a model number" do
    expect(Product.new({ name: "foo" })).to_not be_valid
  end

  it "requires a unique model number" do
    Product.create!({
      name: "foo",
      model_number: "bar",
      description: "baz"
    })

    expect(
      Product.new({ name: "buz", model_number: "bar" })
    ).to_not be_valid
  end

  it "belongs to an instrument" do
    instrument = Instrument.create!({
      name: "instrument name",
      permalink: "instrument-permalink"
    })

    product = Product.create!({
      name: "foo",
      model_number: "bar",
      description: "baz",
      instrument: instrument
    })

    product.reload
    expect(product.instrument).to eq(instrument)
  end

  it "has tags" do
    product = Product.create!({
      name: "foo",
      model_number: "bar",
      description: "baz",
      tag_list: ["tag1", "tag2"]
    })

    product.reload
    expect(product.tag_list).to eq(["tag1", "tag2"])
  end
end
