class ImagesController < ApplicationController
  before_action :set_image, only: :show

  def show
    send_data @image.file, :type => @image.content_type, :disposition => 'inline'
  end

  # POST /images
  def create
    @image = Image.create(image_params)
    render text: @image.id
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def image_params
      params.permit(:file, :content_type, :user_id)
      { file: params[:file].read, name: params[:file].original_filename, content_type: params[:content_type], user_id: params[:user_id] }
    end

    def set_image
      @image = Image.find(params[:id])
    end
end
