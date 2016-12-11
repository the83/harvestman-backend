class Api::V1::TagsController < ApplicationController
  before_filter :authorize_user!, only: [:update, :create, :destroy]
  respond_to :json

  before_filter :find_class_and_obj

  before_filter :sanitize_tags!, only: [:update, :destroy]

  # /tags/products/
  def index
    tags = @klass.tag_counts.map(&:name)
    render json: { tags: tags }
  end

  # /tags/products/:id#get
  def show
    tags = @obj.tag_list
    render json: { tags: tags }
  end

  # /tags/products/:id#put
  def update
    @obj.tag_list.add(@tags)
    @obj.save
    render json: { tags: @obj.tag_list }
  end

  # /tags/products/:id#delete
  def destroy
    @obj.tag_list.remove(@tags)
    @obj.save
    render json: { tags: @obj.tag_list }
  end

  private

  def find_class_and_obj
    @klass = params[:type].singularize.capitalize.constantize
    @obj = @klass.find(params[:id]) if params[:id]
  end

  def sanitize_tags!
    @tags = params[:tags].is_a?(String) ? params[:tags].split(",").map(&:strip) : params[:tags]
    @tags.map!(&:downcase)
  end
end
