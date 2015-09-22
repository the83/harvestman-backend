require "rails_helper"
require "spec_helper"

describe Api::V1::InstrumentsController do
  describe "#show" do
    it "returns a instrument" do
      instrument = Instrument.create!({
        permalink: "foo",
        name: "baz",
        description: "bar",
        brief_description: "buz"
      })

      get :show, { id: instrument.id }

      expected_response = {
        instrument: {
          id: instrument.id,
          permalink: instrument.permalink,
          name: instrument.name,
          description: instrument.description,
          brief_description: instrument.brief_description
        }
      }

      parsed_response = JSON.parse(response.body, { symbolize_names: true })
      expect(parsed_response).to eq(expected_response)
    end
  end

  describe "#index" do
    it "returns a list of instruments" do
      first = Instrument.create!({
        permalink: "foo",
        name: "baz",
        description: "bar",
        brief_description: "buz"
      })

      second = Instrument.create!({
        permalink: "foo2",
        name: "baz2",
        description: "bar2",
        brief_description: "buz"
      })

      get :index

      expected_response = {
        instruments: [
          {
            id: first.id,
            permalink: first.permalink,
            name: first.name,
            description: first.description,
            brief_description: first.brief_description
          },
          {
            id: second.id,
            permalink: second.permalink,
            name: second.name,
            description: second.description,
            brief_description: second.brief_description
          }
        ]
      }
      parsed_response = JSON.parse(response.body, { symbolize_names: true })
      expect(parsed_response).to eq(expected_response)
    end
  end

  describe "#update" do
    it "can update a instrument" do
      instrument = Instrument.create!({
        permalink: "foo",
        name: "baz",
        description: "bar",
        brief_description: "buz"
      })

      update_attributes = {
        id: instrument.id,
        permalink: "new-permalink",
        name: "new name",
        description: "new description",
        brief_description: "new brief description"
      }

      put :update, { id: instrument.id, instrument: update_attributes }

      instrument.reload
      expect(instrument.permalink).to eq(update_attributes[:permalink])
      expect(instrument.name).to eq(update_attributes[:name])
      expect(instrument.description).to eq(update_attributes[:description])
      expect(instrument.brief_description).to eq(update_attributes[:brief_description])

      expected_response = {
        instrument: {
          id: instrument.id,
          permalink: update_attributes[:permalink],
          name: update_attributes[:name],
          description: update_attributes[:description],
          brief_description: update_attributes[:brief_description]
        },
      }
      parsed_response = JSON.parse(response.body, { symbolize_names: true })
      expect(parsed_response).to eq(expected_response)
    end
  end

  describe "#create" do
    it "can create a instrument" do
      create_attributes = {
        permalink: "foo",
        name: "baz",
        description: "bar",
        brief_description: "buz"
      }

      post :create, { instrument: create_attributes }

      instrument = Instrument.last
      expect(instrument.permalink).to eq(create_attributes[:permalink])
      expect(instrument.name).to eq(create_attributes[:name])
      expect(instrument.description).to eq(create_attributes[:description])
      expect(instrument.brief_description).to eq(create_attributes[:brief_description])

      expected_response = {
        instrument: {
          id: instrument.id,
          permalink: instrument.permalink,
          name: instrument.name,
          description: instrument.description,
          brief_description: instrument.brief_description,
        }
      }

      parsed_response = JSON.parse(response.body, { symbolize_names: true })
      expect(parsed_response).to eq(expected_response)
    end

    it "returns an error if the name is not provided" do
      create_attributes = {
        permalink: "foo",
        description: "bar"
      }

      post :create, { instrument: create_attributes }

      expect(response).to_not be_success
      parsed_response = JSON.parse(response.body, { symbolize_names: true })
      expect(parsed_response[:error]).to eq("Error creating instrument.")
    end
  end

  describe "#destroy" do
    it "can destroy a instrument" do
      instrument = Instrument.create!({
        permalink: "foo",
        description: "bar",
        name: "baz"
      })

      delete :destroy, { id: instrument.id }
      expect(Instrument.find_by_id(instrument.id)).to be_nil
    end
  end
end
