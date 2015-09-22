require 'rails_helper'
require 'spec_helper'

describe Instrument do
  it "exists" do
    instrument = Instrument.create!({
      name: "foo",
      permalink: "bar",
      description: "baz",
      brief_description: "buz"
    })

    instrument.reload
    expect(instrument.name).to eq("foo")
    expect(instrument.permalink).to eq("bar")
    expect(instrument.description).to eq("baz")
    expect(instrument.brief_description).to eq("buz")
  end

  it "requires a permalink" do
    expect{
      Instrument.create({ name: "bar" })
    }.to_not change { Instrument.count }
  end

  it "requires a permalink shorter than 30 chars" do
    long_permalink = "a" * 31
    expect{
      Instrument.create({ permalink: long_permalink, name: "bar" })
    }.to_not change { Instrument.count }
  end

  it "requires a unique permalink" do
    Instrument.create({ permalink: "first-permalink", name: "bar" })
    expect{
      Instrument.create({ permalink: "first-permalink", name: "bar" })
    }.to_not change { Instrument.count }
  end

  it "requires a name" do
    expect{
      Instrument.create({ permalink: "foo" })
    }.to_not change { Instrument.count }
  end


  it "has several products" do
     instrument = Instrument.create!({
       name: "instrument name",
       permalink: "instrument-permalink"
     })

     product = Product.create!({
      name: "product 1",
      model_number: "product-1",
      instrument: instrument
    })

    second_product = Product.create!({
      name: "product 2",
      model_number: "product-2",
      instrument: instrument
    })

    expect(instrument.products.include?(product)).to eq(true)
    expect(instrument.products.include?(second_product)).to eq(true)
  end
end
