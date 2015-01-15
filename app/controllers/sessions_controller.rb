class SessionsController < ApplicationController
  def new

  end

  def create
    user = User.find_by(username: params[:session][:username])
    if user
      redirect_to user_path(user)
      flash[:messages] = "You have successfully logged in"
    else
      flash[:errors] = "Invalid credentials"
      render :new
    end
  end

  def destroy
    redirect_to login_path
    flash[:messages] = "You have successfully logged out"
  end
end
