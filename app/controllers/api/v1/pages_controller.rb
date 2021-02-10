class Api::V1::PagesController < ApplicationController
  before_action :authorize_user!, only: [:update, :create, :destroy]
  respond_to :json

  PARAMS_WHITELIST = [:permalink, :content, :title].freeze

  def index
    pages = Page.all.map { |p| PagePresenter.new(p) }
    render({ json: { pages: pages } })
  end

  def show
    page = Page.find_by_permalink(params[:id]) ||
      Page.find_by_id(params[:id])

    render({ json: { page: PagePresenter.new(page) } })
  end

  def create
    page = Page.new(whitelisted_params)

    if page.save
      render({ json: { page: PagePresenter.new(page) } })
    else
      render({ status: 400, json: {
        status: 400, error: "Error creating page." } })
    end
  end

  def update
    page = Page.find_by_id(params[:id])
    page.update_attributes!(whitelisted_params)
    render({ json: { page: PagePresenter.new(page) } })
  end

  def destroy
    page = Page.find_by_id(params[:id])
    page.destroy!
    head 204
  end

  private

  def whitelisted_params
    params.require(:page).permit(PARAMS_WHITELIST)
  end
end
