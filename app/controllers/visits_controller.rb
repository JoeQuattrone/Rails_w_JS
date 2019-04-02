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
      @visit = @hotel.visits.build(start_visit: session[:check_in], end_visit: session[:check_out])
    end
    if session[:user_id]
      @user = User.find_by(id: session[:user_id])
    end
  end

  def check_availability
    @hotel = Hotel.find_by(id: params[:id])
    #parses date string into datetime for Database
    check_in = DateTime.strptime(visit_params[:start_visit], '%m/%d/%Y') rescue nil
    check_out = DateTime.strptime(visit_params[:end_visit], '%m/%d/%Y') rescue nil

    if  check_in.nil? || check_out.nil? || check_in > check_out || check_out.year > 2025 || check_in == ""
      flash[:message] = "We're sorry those dates are not available"
      redirect_to hotel_path(@hotel)
    else
      session[:check_in] = check_in
      session[:check_out] = check_out
      @visit = Visit.new(start_visit: check_in, end_visit: check_out, hotel_id:
      @hotel.id, user_id: session[:id])

      render 'new'
    end
  end

  def last_visit
    @visit = Visit.all.last
    render json: @visit
  end

  def create
    @visit = Visit.create(visit_params)
    session.delete(:check_in)
    session.delete(:check_out)
    render json: @visit, status: 201
  end

  def show
    @user = User.find_by(id: params[:user_id])
    @visit = Visit.find_by(id: params[:id])
    @hotel = @Visit.hotel
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
    params.permit(:start_visit, :end_visit, :user_id, :hotel_id)
  end

end
