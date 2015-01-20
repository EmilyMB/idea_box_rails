module Admin
  class ImagesController < ApplicationController
    before_filter :authorize, only: [:index, :destroy, :new, :create]

    def index
      if current_user.nil? || !current_user.admin?
        redirect_to not_found_path
      end
      @images = Image.all
    end

    def destroy
    #  require 'pry', binding.pry
      # puts "this is id #{id}"

      Image.find(params[:id]).destroy
      flash[:message] = "Image deleted"
      redirect_to images_path
    end

    def new
      @image = Image.new
    end

    def create
      @image = Image.new(image_params)

      respond_to do |format|
        if @image.save
          format.html { redirect_to images_path, notice: 'Image saved.' }
        else
         format.html { render :new }
        end
      end
    #  redirect_to categories_path
    end

    private

    def image_params
      params.require(:image).permit(:link)
    end
  end
end
