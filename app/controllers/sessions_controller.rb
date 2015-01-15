class SessionsController < ApplicationController
  def new

  end

  def create
    user = User.find_by(username: params[:session][:username])
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      flash[:messages] = "You have successfully logged in"
      redirect_to user_path(user)
    else
      flash[:errors] = "Invalid credentials"
      render :new
    end
  end

  def destroy
    session.clear
    flash[:messages] = "You have successfully logged out"
    redirect_to login_path
  end
end
