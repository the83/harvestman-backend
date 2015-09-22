require "rails_helper"
require "spec_helper"

describe Api::V1::PostsController do
  describe "#show" do
    it "returns a post" do
      post = Post.create!({
        permalink: "foo",
        title: "baz",
        content: "bar"
      })

      get :show, { id: post.id }

      expected_response = {
        post: {
          id: post.id,
          permalink: post.permalink,
          title: post.title,
          content: post.content,
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
        content: "bar"
      })

      second = Post.create!({
        permalink: "foo2",
        title: "baz2",
        content: "bar2"
      })

      get :index

      expected_response = {
        posts: [
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
    it "can update a post" do
      post = Post.create!({
        permalink: "foo",
        title: "baz",
        content: "bar"
      })

      update_attributes = {
        id: post.id,
        permalink: "new-permalink",
        title: "new title",
        content: "new content"
      }

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
          content: update_attributes[:content]
        },
      }
      parsed_response = JSON.parse(response.body, { symbolize_names: true })
      expect(parsed_response).to eq(expected_response)
    end
  end

  describe "#create" do
    it "can create a post" do
      create_attributes = {
        permalink: "foo",
        title: "baz",
        content: "bar"
      }

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
  end

  describe "#destroy" do
    it "can destroy a post" do
      post = Post.create!({
        permalink: "foo",
        content: "bar",
        title: "baz",
      })

      delete :destroy, { id: post.id }
      expect(Post.find_by_id(post.id)).to be_nil
    end
  end
end
