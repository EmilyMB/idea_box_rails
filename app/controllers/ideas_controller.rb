class IdeasController < ApplicationController
  #before_filter :authorize, only: [:show]

  def show
    # @user = User.find(params[:id])
    # if @user != current_user && !current_user.admin?
    #   redirect_to not_found_path
    # end
  end

  def new
    @idea = Idea.new(user_id: params[:id])
  end

  def create
    @idea = Idea.create(idea_params)
    redirect_to user_path(@idea.user_id)
  end

  private

  def idea_params
    params.require(:idea).permit(:name, :user_id)
  end
end
