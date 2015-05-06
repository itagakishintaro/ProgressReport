class AttachmentsController < ApplicationController
  before_action :set_attachment, only: :destroy

  # DELETE /attachments/1
  def destroy
    @attachment.destroy
    redirect_to :back
  end

  private
    def set_attachment
      @attachment = Attachment.find(params[:id])
    end
end
