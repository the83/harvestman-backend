class Api::V1::InstrumentsController < ApplicationController
  before_filter :authorize_user!, only: [:update, :create, :destroy]

  respond_to :json

  PARAMS_WHITELIST = [
    :permalink,
    :description,
    :brief_description,
    :name
  ].freeze

  def index
    instruments = Instrument.all.map { |p| InstrumentPresenter.new(p) }
    render({ json: { instruments: instruments } })
  end

  def show
    instrument = Instrument.find_by_permalink(params[:id]) ||
      Instrument.find_by_id(params[:id])

    return head 404 unless instrument

    render({ json: { instrument: InstrumentPresenter.new(instrument) } })
  end

  def create
    instrument = Instrument.new(whitelisted_params)

    if instrument.save
      render({ json: { instrument: InstrumentPresenter.new(instrument) } })
    else
      render({ status: 400, json: {
        status: 400, error: "Error creating instrument." } })
    end
  end

  def update
    instrument = Instrument.find_by_id(params[:id])
    instrument.update_attributes!(whitelisted_params)
    render({ json: { instrument: InstrumentPresenter.new(instrument) } })
  end

  def destroy
    instrument = Instrument.find_by_id(params[:id])
    instrument.destroy!
    head 204
  end

  private

  def whitelisted_params
    params.require(:instrument).permit(PARAMS_WHITELIST)
  end
end
