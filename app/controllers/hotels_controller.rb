class HotelsController < ApplicationController
  before_action :set_user
  layout "hotels"

  def index
    if session[:hotel_search]
      @hotels = Hotel.query_by_city(session[:hotel_search])
    end
  end

  def search
    city_name = hotel_params["city"].capitalize
    budget = hotel_params[:budget]

    @hotels = Hotel.query_by_city(city_name)
    if @hotels.empty?
      Hotel.get_data2(city_name)
      @hotels = Hotel.query_by_city(city_name)
    end

    #querys hotel on price if budget is submitted
    if !budget.empty?
      @hotels = @hotels.query_by_price(budget)
    end

    session[:hotel_search] = city_name
    if @hotels.empty?
      flash[:message] = "Please enter a valid city"
      redirect_to root_path
    else
      render 'hotels/index'
    end
  end

  def new

  end

  def create

  end

  def show
    @hotel = Hotel.find_by(id: params[:id])
    if !@hotel
      flash[:message] = "Sorry we couldn't find that hotel"
      redirect_to root_path
    end
  end

  def edit

  end

  def update

  end

  def destroy

  end

  private

  def hotel_params
    params.require(:hotel).permit(:city, :budget)
  end

end
