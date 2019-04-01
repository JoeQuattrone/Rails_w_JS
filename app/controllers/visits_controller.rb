require 'date'

class VisitsController < ApplicationController
  layout "hotels"

  def index
    @user = User.find_by(id: params[:user_id])
    @visits = @user.visits.all
    render :layout => "login_register"
  end

  def new
    if params[:hotel_id]
      @hotel = Hotel.find_by(id: params[:hotel_id])
      @visit = @hotel.visits.last
    end
  end

  def check_availability
    @hotel = Hotel.find_by(id: params[:id])

    #parses date string into datetime for Database
    check_in = DateTime.strptime(visit_params[:check_in], '%m/%d/%Y') rescue nil
    check_out = DateTime.strptime(visit_params[:check_out], '%m/%d/%Y') rescue nil

    if check_in.nil? || check_out.nil? || check_in > check_out || check_out.year > 2025
      flash[:message] = "We're sorry those dates are not available"
      redirect_to hotel_path(@hotel)
    else
      @visit = Visit.create(start_visit: check_in, end_visit: check_out, hotel_id: @hotel.id, user_id: session[:id])
      render 'new'
    end
  end

  def create
    @visit = Visit.find_by(id: params[:visit_id])
    @visit.user_id = params[:user_id].to_i
    @visit.save

    if @visit.user
      flash[:message] = "Thank you for booking with J-Travel!"
      redirect_to user_visit_path(@visit.user, @visit.id)

    else
      flash[:message] = "Please login or Register to book your visit!"
      redirect_to signin_path
    end
  end

  def show
    @user = User.find_by(id: params[:user_id])
    @visit = Visit.find_by(id: params[:id])
    @hotel = @visit.hotel
  end

  def edit

  end

  def update

  end

  def destroy
    @user = User.find_by(id: params[:user_id])
    @visit = Visit.find_by(id: params[:id]).delete
    redirect_to user_visits_path(@user)
  end

  private

  def visit_params
    params.permit(:check_in, :check_out, :visit_id, :user_id, :hotel_id)
  end

end
