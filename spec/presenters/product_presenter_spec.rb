require "rails_helper"
require "spec_helper"
require "product_presenter"

describe ProductPresenter do
  it "presents a product" do
    product = Product.create!({
      name: "foo",
      model_number: "bar",
      description: "baz",
      brief_description: "brief",
      manual: "buz",
      tag_list: ["tag1", "tag2"]
    })

    presented = ({
      id: product.id,
      name: product.name,
      model_number: product.model_number,
      description: product.description,
      manual: product.manual,
      brief_description: product.brief_description,
      tag_list: product.tag_list
    }).to_json

    expect(ProductPresenter.new(product).to_json).to eq(presented)
  end
end
