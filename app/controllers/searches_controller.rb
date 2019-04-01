class SearchesController < ApplicationController
  def index
    city_name = hotel_params["city"].capitalize
    budget = hotel_params[:budget]

    @hotels = Hotel.query_by_city(city_name)
    render json: @hotels
  end
end
