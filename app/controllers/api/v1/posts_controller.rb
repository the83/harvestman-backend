class Api::V1::PostsController < ApplicationController
  PARAMS_WHITELIST = [:permalink, :content, :title].freeze

  def index
    posts = Post.all.map { |p| PostPresenter.new(p) }
    render({ json: { posts: posts } })
  end

  def show
    post = Post.find_by_permalink(params[:id]) ||
      Post.find_by_id(params[:id])

    render({ json: { post: PostPresenter.new(post) } })
  end

  def create
    post = Post.new(whitelisted_params)

    if post.save
      render({ json: { post: PostPresenter.new(post) } })
    else
      render({ status: 400, json: {
        status: 400, error: "Error creating post." } })
    end
  end

  def update
    post = Post.find_by_id(params[:id])
    post.update_attributes!(whitelisted_params)
    render({ json: { post: PostPresenter.new(post) } })
  end

  def destroy
    post = Post.find_by_id(params[:id])
    post.destroy!
    head 204
  end

  private

  def whitelisted_params
    params.require(:post).permit(PARAMS_WHITELIST)
  end
end
