class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  helper_method :current_user

  def authorize
    #require 'pry'; binding.pry
    redirect_to not_found_path if current_user.nil?
   #raise ActionController::RoutingError.new('Not Found') if current_user.nil?
  #  render status: 404 if current_user.nil?
    # render :status => 404 if current_user.nil?
  end
end
