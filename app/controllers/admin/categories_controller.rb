module Admin
  class CategoriesController < ApplicationController
    before_filter :authorize, only: [:index, :destroy, :new, :create]

    def index
      if current_user.nil? || !current_user.admin?
        redirect_to not_found_path
      end
      @categories = Category.all
    end

    def destroy
      # Category.destroy(params[:id])
      flash[:notice] = "You have successfully deleted the category."
      redirect_to categories_path
    end

    def new
      @category = Category.new
    end

    def create
      @category = Category.new(category_params)

      respond_to do |format|
        if @category.save
          format.html { redirect_to categories_path, notice: 'Category was successfully created.' }
        else
         format.html { render :new }
        end
      end
    #  redirect_to categories_path
    end

    private

    def category_params
      params.require(:category).permit(:name)
    end
  end
end
