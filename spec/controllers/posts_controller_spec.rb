require "rails_helper"
require "spec_helper"

describe Api::V1::PostsController do
  describe "#show" do
    it "returns a post" do
      post = Post.create!({
        permalink: "foo",
        title: "baz",
        content: "bar",
        tag_list: ["tag1", "tag2"]
      })

      get :show, { id: post.id }

      expected_response = {
        post: {
          id: post.id,
          permalink: post.permalink,
          title: post.title,
          content: post.content,
          tag_list: post.tag_list,
          images: [],
          date: post.created_at.in_time_zone(
            PostPresenter::TIME_ZONE
          ).strftime(PostPresenter::TIME_FORMAT)
        }
      }

      parsed_response = JSON.parse(response.body, { symbolize_names: true })
      expect(parsed_response).to eq(expected_response)
    end
  end

  describe "#index" do
    it "returns a list of posts" do
      first = Post.create!({
        permalink: "foo",
        title: "baz",
        content: "bar",
        tag_list: ["tag1", "tag2"]
      })

      second = Post.create!({
        permalink: "foo2",
        title: "baz2",
        content: "bar2",
        tag_list: ["tag1", "tag2"]
      })

      get :index

      expected_response = {
        posts: [
          {
            id: first.id,
            permalink: first.permalink,
            title: first.title,
            content: first.content,
            tag_list: first.tag_list,
            images: [],
            date: first.created_at.in_time_zone(
              PostPresenter::TIME_ZONE
            ).strftime(PostPresenter::TIME_FORMAT)
          },
          {
            id: second.id,
            permalink: second.permalink,
            title: second.title,
            content: second.content,
            tag_list: second.tag_list,
            images: [],
            date: second.created_at.in_time_zone(
              PostPresenter::TIME_ZONE
            ).strftime(PostPresenter::TIME_FORMAT)
          }
        ]
      }
      parsed_response = JSON.parse(response.body, { symbolize_names: true })
      expect(parsed_response).to eq(expected_response)
    end
  end

  describe "#update" do
    before(:each) { sign_in }
    let(:post) do
      Post.create!({
        permalink: "foo",
        title: "baz",
        content: "bar",
        tag_list: ["tag1", "tag2"]
      })
    end

    let(:update_attributes) do
      {
        id: post.id,
        permalink: "new-permalink",
        title: "new title",
        content: "new content",
        tag_list: ["newtag1", "newtag2"],
        images: []
      }
    end

    it "can update a post" do
      put :update, { id: post.id, post: update_attributes }

      post.reload
      expect(post.permalink).to eq(update_attributes[:permalink])
      expect(post.title).to eq(update_attributes[:title])
      expect(post.content).to eq(update_attributes[:content])

      expected_response = {
        post: {
          id: post.id,
          permalink: update_attributes[:permalink],
          title: update_attributes[:title],
          content: update_attributes[:content],
          tag_list: update_attributes[:tag_list],
          images: [],
          date: post.created_at.in_time_zone(
            PostPresenter::TIME_ZONE
          ).strftime(PostPresenter::TIME_FORMAT)
        },
      }
      parsed_response = JSON.parse(response.body, { symbolize_names: true })
      expect(parsed_response).to eq(expected_response)
    end

    context "without a signed in user" do
      before(:each) { sign_out }

      it "returns a 401" do
        put :update, { id: post.id, post: update_attributes }
        expect(response).to_not be_success
        expect(response.code).to eq("401")

        post.reload
        expect(post.title).to eq("baz")
      end
    end
  end

  describe "#create" do
    before(:each) { sign_in }
    let(:create_attributes) do
      {
        permalink: "foo",
        title: "baz",
        content: "bar",
        tag_list: ["tag1", "tag2"]
      }
    end

    it "can create a post" do
      post :create, { post: create_attributes }

      post = Post.last
      expect(post.permalink).to eq(create_attributes[:permalink])
      expect(post.title).to eq(create_attributes[:title])
      expect(post.content).to eq(create_attributes[:content])

      expected_response = {
        post: {
          id: post.id,
          permalink: post.permalink,
          title: post.title,
          content: post.content,
          tag_list: post.tag_list,
          images: [],
          date: post.created_at.in_time_zone(
            PostPresenter::TIME_ZONE
          ).strftime(PostPresenter::TIME_FORMAT)
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

      post :create, { post: create_attributes }

      expect(response).to_not be_success
      parsed_response = JSON.parse(response.body, { symbolize_names: true })
      expect(parsed_response[:error]).to eq("Error creating post.")
    end

    context "without a signed in user" do
      before(:each) { sign_out }

      it "returns a 401" do
        post :create, { post: create_attributes }
        expect(response).to_not be_success
        expect(response.code).to eq("401")
      end
    end
  end

  describe "#destroy" do
    before(:each) { sign_in }
    let(:post) do
      Post.create!({
        permalink: "foo",
        content: "bar",
        title: "baz",
      })
    end

    it "can destroy a post" do
      delete :destroy, { id: post.id }
      expect(Post.find_by_id(post.id)).to be_nil
    end

    context "without a signed in user" do
      before(:each) { sign_out }

      it "can returns a 401" do
        delete :destroy, { id: post.id }
        expect(response).to_not be_success
        expect(response.code).to eq("401")
      end
    end
  end
end
