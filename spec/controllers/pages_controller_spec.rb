require "rails_helper"
require "spec_helper"

describe Api::V1::PagesController do
  describe "#show" do
    it "returns a page" do
      page = Page.create!({
        permalink: "foo",
        title: "baz",
        content: "bar"
      })

      get :show, { id: page.id }

      expected_response = {
        page: {
          id: page.id,
          permalink: page.permalink,
          title: page.title,
          content: page.content,
        }
      }

      parsed_response = JSON.parse(response.body, { symbolize_names: true })
      expect(parsed_response).to eq(expected_response)
    end
  end

  describe "#index" do
    it "returns a list of pages" do
      first = Page.create!({
        permalink: "foo",
        title: "baz",
        content: "bar"
      })

      second = Page.create!({
        permalink: "foo2",
        title: "baz2",
        content: "bar2"
      })

      get :index

      expected_response = {
        pages: [
          {
            id: first.id,
            permalink: first.permalink,
            title: first.title,
            content: first.content
          },
          {
            id: second.id,
            permalink: second.permalink,
            title: second.title,
            content: second.content
          }
        ]
      }
      parsed_response = JSON.parse(response.body, { symbolize_names: true })
      expect(parsed_response).to eq(expected_response)
    end
  end

  describe "#update" do
    before(:each) { sign_in }
    let(:page) do
      Page.create!({
        permalink: "foo",
        title: "baz",
        content: "bar"
      })
    end

    let(:update_attributes) do
      {
        id: page.id,
        permalink: "new-permalink",
        title: "new title",
        content: "new content"
      }
    end

    context "with a signed in user" do
      it "can update a page" do
        put :update, { id: page.id, page: update_attributes }

        page.reload
        expect(page.permalink).to eq(update_attributes[:permalink])
        expect(page.title).to eq(update_attributes[:title])
        expect(page.content).to eq(update_attributes[:content])

        expected_response = {
          page: {
            id: page.id,
            permalink: update_attributes[:permalink],
            title: update_attributes[:title],
            content: update_attributes[:content]
          },
        }
        parsed_response = JSON.parse(response.body, { symbolize_names: true })
        expect(parsed_response).to eq(expected_response)
      end
    end

    context "without a signed in user" do
      before(:each) { sign_out }

      it "returns a 401" do
        put :update, { id: page.id, page: update_attributes }
        expect(response).to_not be_success
        expect(response.code).to eq("401")

        page.reload
        expect(page.title).to eq("baz")
      end
    end
  end

  describe "#create" do
    let(:create_attributes) do
      {
        permalink: "foo",
        title: "baz",
        content: "bar"
      }
    end

    context "with a signed in user" do
      before(:each) { sign_in }

      it "can create a page" do
        post :create, { page: create_attributes }

        page = Page.last
        expect(page.permalink).to eq(create_attributes[:permalink])
        expect(page.title).to eq(create_attributes[:title])
        expect(page.content).to eq(create_attributes[:content])

        expected_response = {
          page: {
            id: page.id,
            permalink: page.permalink,
            title: page.title,
            content: page.content,
          }
        }

        parsed_response = JSON.parse(response.body, { symbolize_names: true })
        expect(parsed_response).to eq(expected_response)
      end

      it "returns an error if the title is not provided" do
        create_attributes = {
          permalink: "foo",
          content: "bar"
        }

        post :create, { page: create_attributes }

        expect(response).to_not be_success
        parsed_response = JSON.parse(response.body, { symbolize_names: true })
        expect(parsed_response[:error]).to eq("Error creating page.")
      end
    end

    context "without a signed in user" do
      before(:each) { sign_out }

      it "returns a 401" do
        post :create, { page: create_attributes }

        expect(response).to_not be_success
        expect(response.code).to eq("401")
      end
    end
  end

  describe "#destroy" do
    let(:page) do
      Page.create!({
        permalink: "foo",
        content: "bar",
        title: "baz",
      })
    end

    context "with a signed in user" do
      before(:each) { sign_in }

      it "can destroy a page" do
        delete :destroy, { id: page.id }
        expect(Page.find_by_id(page.id)).to be_nil
      end
    end

    context "without a signed in user" do
      before(:each) { sign_out }
      it "returns a 401" do
        delete :destroy, { id: page.id }
        expect(response).to_not be_success
        expect(response.code).to eq("401")
      end
    end
  end
end
