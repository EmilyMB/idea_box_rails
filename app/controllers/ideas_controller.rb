class IdeasController < ApplicationController
  before_filter :authorize, only: [:create, :edit, :update, :destroy]

  before_action :set_idea, only: [ :edit, :update, :destroy]

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

  def destroy
    user_id = @idea.user_id
    @idea.destroy
    flash[:message] = "Idea deleted"
    redirect_to user_path(user_id)
  end

  def edit
    if current_user.id != @idea.user_id
      redirect_to not_found_path
    end
  end


  def update
    @idea.update(idea_params)
    redirect_to user_path(@idea.user_id), notice: 'Idea was successfully updated.'
  end

  private

  def idea_params
    params.require(:idea).permit(:name, :user_id)
  end

  def set_idea
    @idea = Idea.find(params[:id])
  end
end
