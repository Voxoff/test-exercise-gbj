class DeliveriesController < ApplicationController
  def index
    @deliveries = Delivery.where(nil)
    @deliveries = @deliveries.filter_by_delivery_date(delivery_date_params) if delivery_date_params
  end

  def show
    @delivery = Delivery.find(params[:id])
  end

  private

  def delivery_date_params
    date = params.permit(:delivery_date)[:delivery_date]
    date if date && date.match(/\d{4}-\d{2}-\d{2}/)
  end
end
