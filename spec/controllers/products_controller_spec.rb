require "rails_helper"
require "spec_helper"

describe Api::V1::ProductsController do
  describe "#show" do
    it "returns a product" do
      product = Product.create!({
        name: "foo",
        model_number: "bar",
        description: "baz"
      })

      get :show, { id: product.id }

      expected_response = {
        product: {
          id: product.id,
          name: product.name,
          model_number: product.model_number,
          description: product.description
        }
      }

      parsed_response = JSON.parse(response.body, { symbolize_names: true })
      expect(parsed_response).to eq(expected_response)
    end
  end

  describe "#index" do
    it "returns a list of products" do
      first = Product.create!({
        name: "Piston Honda",
        model_number: "1991mk2",
        description: "wavetable oscillator"
      })

      second = Product.create!({
        name: "Hertz Donut",
        model_number: "9792mk2",
        description: "complex oscillator"
      })

      get :index

      expected_response = {
        products: [
          {
            id: first.id,
            name: first.name,
            model_number: first.model_number,
            description: first.description
          },
          {
            id: second.id,
            name: second.name,
            model_number: second.model_number,
            description: second.description
          },
        ]
      }
      parsed_response = JSON.parse(response.body, { symbolize_names: true })
      expect(parsed_response).to eq(expected_response)
    end
  end

  describe "#update" do
    it "can update a product" do
      product = Product.create!({
        name: "Piston Honda",
        model_number: "1991mk2",
        description: "wavetable oscillator"
      })

      update_attributes = {
        id: product.id,
        name: "New Name",
        description: "New Description"
      }

      put :update, { id: product.id, product: update_attributes }

      product.reload
      expect(product.name).to eq(update_attributes[:name])
      expect(product.description).to eq(update_attributes[:description])

      expected_response = {
        product: {
          id: product.id,
          name: update_attributes[:name],
          model_number: product.model_number,
          description: update_attributes[:description]
        },
      }
      parsed_response = JSON.parse(response.body, { symbolize_names: true })
      expect(parsed_response).to eq(expected_response)
    end
  end

  describe "#create" do
    it "can create a product" do
      create_attributes = {
        name: "Piston Honda",
        model_number: "1991mk2",
        description: "wavetable oscillator"
      }

      post :create, { product: create_attributes }

      product = Product.last
      expect(product.name).to eq(create_attributes[:name])
      expect(product.model_number).to eq(create_attributes[:model_number])
      expect(product.description).to eq(create_attributes[:description])

      expected_response = {
        product: {
          id: product.id,
          name: product.name,
          model_number: product.model_number,
          description: product.description
        },
      }

      parsed_response = JSON.parse(response.body, { symbolize_names: true })
      expect(parsed_response).to eq(expected_response)
    end

    it "returns an error if the model_number is not provided" do
      create_attributes = {
        name: "Piston Honda",
        description: "wavetable oscillator"
      }

      post :create, { product: create_attributes }

      expect(response).to_not be_success
      parsed_response = JSON.parse(response.body, { symbolize_names: true })
      expect(parsed_response[:error]).to eq("Error creating product.")
    end
  end

  describe "#destroy" do
    it "can destroy a product" do
      product = Product.create!({
        name: "Piston Honda",
        model_number: "1991mk2",
        description: "wavetable oscillator"
      })

      delete :destroy, { id: product.id }
      expect(Product.find_by_id(product.id)).to be_nil
    end
  end
end
