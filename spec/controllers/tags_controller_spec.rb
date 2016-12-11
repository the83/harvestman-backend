require "rails_helper"
require 'spec_helper'

describe Api::V1::TagsController do
  before :each do
    @tags = ["foo", "bar", "baz"]
    @product = Product.new({ model_number: 'model-number' })
    @product.tag_list.add(@tags)
    @product.save!
  end

  describe "#index" do
    it "fetches all tags for products" do
      get :index, { type: "products" }
      parsed_response = JSON.parse(response.body, { symbolize_names: true })
      expect(parsed_response[:tags]).to match_array(@tags)
    end
  end

  describe "#show" do
    it "fetches all tags for a specific product" do
      get :show, { type: "products", id: @product.id }
      parsed_response = JSON.parse(response.body, { symbolize_names: true })
      expect(parsed_response[:tags]).to match_array(@tags)
    end
  end

  describe "#update" do
    before(:each) { sign_in }

    it "sets tags for a specific product" do
      new_tags = ["some", "new", "tags"]
      expected_tags = @product.tag_list + new_tags
      put :update, { type: "products", id: @product.id, tags: new_tags }

      @product.reload
      expect(@product.tag_list).to match_array(expected_tags)

      parsed_response = JSON.parse(response.body, { symbolize_names: true })
      expect(parsed_response[:tags]).to match_array(expected_tags)
    end

    it "coerces a tag string into an array" do
      new_tags = "some, new, tags"
      expected_tags = @product.tag_list + ["some", "new", "tags"]
      put :update, { type: "products", id: @product.id, tags: new_tags }

      @product.reload
      expect(@product.tag_list).to match_array(expected_tags)

      parsed_response = JSON.parse(response.body, { symbolize_names: true })
      expect(parsed_response[:tags]).to match_array(expected_tags)
    end

    it "downcases tags" do
      new_tags = ["UpperCaseTag"]
      expected_tags = @product.tag_list + ["uppercasetag"]
      put :update, { type: "products", id: @product.id, tags: new_tags }

      @product.reload
      expect(@product.tag_list).to match_array(expected_tags)

      parsed_response = JSON.parse(response.body, { symbolize_names: true })
      expect(parsed_response[:tags]).to match_array(expected_tags)
    end

    context "without a signed in user" do
      before(:each) { sign_out }

      it "returns a 401" do
        new_tags = "some, new, tags"
        put :update, { type: "products", id: @product.id, tags: new_tags }
        expect(response).to_not be_success
        expect(response.code).to eq("401")
      end
    end
  end

  describe "#destroy" do
    before(:each) { sign_in }

    it "removes tags for a specific product" do
      delete_me = ["foo", "bar"]
      expected_tags = @product.tag_list - delete_me
      delete :destroy, { type: "products", id: @product.id, tags: delete_me }

      @product.reload
      expect(@product.tag_list).to match_array(expected_tags)

      parsed_response = JSON.parse(response.body, { symbolize_names: true })
      expect(parsed_response[:tags]).to match_array(expected_tags)
    end

    it "coerces a tag string into an array" do
      delete_me = "bar, baz"
      expected_tags = ["foo"]
      delete :destroy, { type: "products", id: @product.id, tags: delete_me }

      @product.reload
      expect(@product.tag_list).to eq(expected_tags)

      parsed_response = JSON.parse(response.body, { symbolize_names: true })
      expect(parsed_response[:tags]).to match_array(expected_tags)
    end

    it "downcases tags" do
      delete_me = ["Foo"]
      expected_tags = @product.tag_list - ["foo"]
      delete :destroy, { type: "products", id: @product.id, tags: delete_me }

      @product.reload
      expect(@product.tag_list).to match_array(expected_tags)

      parsed_response = JSON.parse(response.body, { symbolize_names: true })
      expect(parsed_response[:tags]).to match_array(expected_tags)
    end

    context "without a signed in user" do
      before(:each) { sign_out }

      it "returns a 401" do
        delete_me = ["Foo"]
        delete :destroy, { type: "products", id: @product.id, tags: delete_me }
        expect(response).to_not be_success
        expect(response.code).to eq("401")
      end
    end
  end
end
