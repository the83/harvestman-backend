require "rails_helper"
require "spec_helper"
require "instrument_presenter"

describe InstrumentPresenter do
  it "presents a instrument" do
    instrument = Instrument.create!({
      name: "foo",
      permalink: "bar",
      description: "baz",
      brief_description: "buz"
    })

    presented = ({
      id: instrument.id,
      permalink: instrument.permalink,
      name: instrument.name,
      description: instrument.description,
      brief_description: instrument.brief_description
    }).to_json

    expect(InstrumentPresenter.new(instrument).to_json).to eq(presented)
  end
end
