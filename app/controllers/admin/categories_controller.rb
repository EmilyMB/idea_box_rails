module Admin
  class CategoriesController < ApplicationController

    def index
      @categories = Category.all
    end

    def destroy
      # Category.destroy(params[:id])
      flash[:notice] = "You have successfully deleted the category."
      redirect_to categories_path
    end
  end
end
