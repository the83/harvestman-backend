class Api::V1::PostsController < ApplicationController
  before_filter :authorize_user!, only: [:update, :create, :destroy]
  respond_to :json

  PARAMS_WHITELIST = [
    :permalink,
    :content,
    :title,
    :tag_list => [],
    images_attributes: [:id, :image],
  ].freeze

  def index
    posts = Post.all.order("created_at DESC")
      .map { |p| PostPresenter.new(p) }
    render({ json: { posts: posts } })
  end

  def show
    post = Post.find_by_permalink(params[:id]) ||
      Post.find_by_id(params[:id])

    return head 404 unless post

    render({ json: { post: PostPresenter.new(post) } })
  end

  def create
    post = Post.new(whitelisted_params.except(:images_attributes))

    if post.save
      build_images_for(post)
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

  def build_images_for(model)
    images_attributes = whitelisted_params.slice(:images_attributes)
    return if images_attributes.blank?
    images_attributes["images_attributes"].each do |p|
      model.images << Image.find_by_id(p["id"])
    end
  end

  def whitelisted_params
    params.required(:post).permit(*PARAMS_WHITELIST)
  end
end
