require "rails_helper"
require "spec_helper"
require "base_presenter"

class TestPresenter < BasePresenter
  def attributes
    {
      foo: @object.foo,
      bar: @object.bar
    }
  end
end

describe BasePresenter do
  describe "#as_json" do
    it "only presents the attributes in the attributes hash" do
      test_class = OpenStruct.new({
        foo: "foos",
        bar: "bars",
        baz: "bazzes"
      })

      presented = TestPresenter.new(test_class).as_json
      expect(presented[:foo]).to eq("foos")
      expect(presented[:bar]).to eq("bars")
      expect(presented[:baz]).to be_nil
    end
  end
end
