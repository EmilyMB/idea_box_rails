class UsersController < ApplicationController
  before_filter :authorize, only: [:show]

  def show
    @user = User.find(params[:id])
    if @user != current_user && !current_user.admin?
      redirect_to not_found_path
    end
  end
end
