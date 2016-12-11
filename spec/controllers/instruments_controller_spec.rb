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
    let(:instrument) do
      Instrument.create!({
        permalink: "foo",
        name: "baz",
        description: "bar",
        brief_description: "buz"
      })
    end

    let(:update_attributes) do
      update_attributes = {
        id: instrument.id,
        permalink: "new-permalink",
        name: "new name",
        description: "new description",
        brief_description: "new brief description"
      }
    end

    context "with a signed in user" do
      before(:each) { sign_in }

      it "can update a instrument" do
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

    context "without a signed in user" do
      before(:each) { sign_out }

      it "returns a 401" do
        put :update, { id: instrument.id, instrument: update_attributes }
        expect(response.code).to eq("401")

        instrument.reload
        expect(instrument.name).to eq("baz")
      end
    end
  end

  describe "#create" do
    let(:create_attributes) do
      {
        permalink: "foo",
        name: "baz",
        description: "bar",
        brief_description: "buz"
      }
    end

    context "with a signed in user" do
      before(:each) { sign_in }

      it "can create a instrument" do
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

    context "without a signed in user" do
      before(:each) { sign_out }

      it "returns a 401" do
        post :create, { instrument: create_attributes }
        expect(response).to_not be_success
        expect(response.code).to eq("401")
      end
    end
  end

  describe "#destroy" do
    let(:instrument) do
      Instrument.create!({
        permalink: "foo",
        description: "bar",
        name: "baz"
      })
    end

    context "with a signed in user" do
      before(:each) { sign_in }

      it "can destroy a instrument" do
        delete :destroy, { id: instrument.id }
        expect(Instrument.find_by_id(instrument.id)).to be_nil
      end
    end

    context "without a signed in user" do
      before(:each) { sign_out }

      it "returns a 401" do
        delete :destroy, { id: instrument.id }
        expect(response).to_not be_success
        expect(response.code).to eq("401")
      end
    end
  end
end
