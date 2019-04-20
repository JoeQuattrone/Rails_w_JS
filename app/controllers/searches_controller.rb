class SearchesController < ApplicationController
  def index
    city_name = searches_params["city"].capitalize
    budget = searches_params[:budget]

    @hotels = Hotel.query_by_city(city_name)
    if @hotels.empty?
      Hotel.get_data2(city_name)
      @hotels = Hotel.query_by_city(city_name)
    end
    #querys hotel on price if budget is submitted
    @hotels = @hotels.query_by_price(budget) if !budget.empty?

    render json: @hotels, each_serializer: SearchesSerializer
  end

  def all_hotels
    @hotels = Hotel.all
    render json: @hotels, each_serializer: SearchesSerializer
  end





  private

  def searches_params
    params.require(:hotel).permit(:city, :budget)
  end
end
