class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  def logged_in?(user)
    session[:user_id] == user.id
  end

  def set_user
    if self.session[:user_id]
      @user = User.find_by(id: self.session[:user_id])
    end
  end
end
