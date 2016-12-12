require "rails_helper"
require "spec_helper"

describe Api::V1::ProductsController do
  describe "#show" do
    it "returns a product" do
      product = Product.create!({
        name: "foo",
        model_number: "bar",
        description: "baz",
        brief_description: "brief",
        manual: "buz",
        tag_list: ["tag1", "tag2"],
        features: "some features",
        firmwares: [],
      })

      get :show, { id: product.id }

      expected_response = {
        product: {
          id: product.id,
          name: product.name,
          model_number: product.model_number,
          description: product.description,
          brief_description: product.brief_description,
          manual: product.manual,
          tag_list: product.tag_list,
          images: [],
          features: "some features",
          firmwares: [],
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
        description: "wavetable oscillator",
        brief_description: "brief",
        manual: "piston honda manual",
        tag_list: ["tag1", "tag2"],
        features: "some features",
      })

      second = Product.create!({
        name: "Hertz Donut",
        model_number: "9792mk2",
        description: "complex oscillator",
        brief_description: "brief",
        manual: "Hertz Manual",
        tag_list: ["tag1", "tag2"],
        features: "some other features",
      })

      get :index

      expected_response = {
        products: [
          {
            id: second.id,
            name: second.name,
            model_number: second.model_number,
            description: second.description,
            brief_description: second.brief_description,
            manual: second.manual,
            tag_list: second.tag_list,
            images: [],
            features: second.features,
            firmwares: [],
          },
          {
            id: first.id,
            name: first.name,
            model_number: first.model_number,
            description: first.description,
            brief_description: first.brief_description,
            manual: first.manual,
            tag_list: first.tag_list,
            images: [],
            features: first.features,
            firmwares: [],
          },
        ]
      }
      parsed_response = JSON.parse(response.body, { symbolize_names: true })
      expect(parsed_response).to eq(expected_response)
    end
  end

  describe "#update" do
    before(:each) { sign_in }
    let(:product) do
      Product.create!({
        name: "Piston Honda",
        model_number: "1991mk2",
        description: "wavetable oscillator",
        brief_description: "brief",
        manual: "piston manual",
        tag_list: ["tag1", "tag2"],
        features: "some features"
      })
    end

    it "can update a product" do
      update_attributes = {
        id: product.id,
        name: "New Name",
        description: "New Description",
        brief_description: "brief",
        manual: "New Manual",
        tag_list: ["newtag1", "newtag2"],
        features: "new features"
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
          description: update_attributes[:description],
          brief_description: update_attributes[:brief_description],
          manual: update_attributes[:manual],
          tag_list: update_attributes[:tag_list],
          images: [],
          features: update_attributes[:features],
          firmwares: [],
        },
      }
      parsed_response = JSON.parse(response.body, { symbolize_names: true })
      expect(parsed_response).to eq(expected_response)
    end

    context "without a signed in user" do
      before(:each) { sign_out }

      it "returns a 401" do
        update_attributes = {
          name: "New Name",
        }

        put :update, { id: product.id, product: update_attributes }
        expect(response).to_not be_success
        expect(response.code).to eq("401")

        product.reload
        expect(product.name).to eq("Piston Honda")
      end
    end
  end

  describe "#create" do
    before(:each) { sign_in }
    let(:create_attributes) do
      {
        name: "Piston Honda",
        model_number: "1991mk2",
        description: "wavetable oscillator",
        brief_description: "brief",
        manual: "Piston Manual",
        tag_list: ["tag1", "tag2"],
        features: "some features"
      }
    end

    it "can create a product" do
      post :create, { product: create_attributes }

      product = Product.last
      expect(product.name).to eq(create_attributes[:name])
      expect(product.model_number).to eq(create_attributes[:model_number])
      expect(product.description).to eq(create_attributes[:description])
      expect(product.brief_description).to eq(create_attributes[:brief_description])
      expect(product.features).to eq(create_attributes[:features])

      expected_response = {
        product: {
          id: product.id,
          name: product.name,
          model_number: product.model_number,
          description: product.description,
          brief_description: product.brief_description,
          manual: product.manual,
          tag_list: product.tag_list,
          images: [],
          features: "some features",
          firmwares: [],
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

    context "without a logged in user" do
      before(:each) { sign_out }

      it "returns a 401" do
        post :create, { product: create_attributes }
        expect(response).to_not be_success
        expect(response.code).to eq("401")
      end
    end
  end

  describe "#destroy" do
    before(:each) { sign_in }
    let(:product) do
      Product.create!({
        name: "Piston Honda",
        model_number: "1991mk2",
        description: "wavetable oscillator"
      })
    end

    it "can destroy a product" do
      delete :destroy, { id: product.id }
      expect(Product.find_by_id(product.id)).to be_nil
    end

    context "without a signed in user" do
      before(:each) { sign_out }

      it "returns a 401" do
        delete :destroy, { id: product.id }
        expect(response).to_not be_success
        expect(response.code).to eq("401")
      end
    end
  end
end
