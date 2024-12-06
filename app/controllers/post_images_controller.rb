class PostImagesController < ApplicationController

  private
  def post_image_params
    params.require(:post_image).permit(:shop_name, :image, :caption, :address)
  end

  
end
